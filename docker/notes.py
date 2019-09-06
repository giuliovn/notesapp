#!/usr/bin/env python3

from flask import Flask, render_template, request, redirect, url_for
import mysql.connector
import os

app = Flask(__name__)

def connect_db():
    mydb = mysql.connector.connect(
        host=os.environ['DB_HOST'],
        user="root",
        passwd="notes",
        database="Notes",
        auth_plugin='mysql_native_password'
    )
    return mydb

@app.route("/")
def index():
    db = connect_db()
    cursor = db.cursor()
    cursor.execute("SELECT user from Users")
    results = cursor.fetchall()
    users = []
    for entry in results:
        users.append(entry[0])
    db.close()
    return render_template("index.html", users=users)

@app.route("/<user>", methods = ["GET", "POST"])
def user(user):
    if request.method == "POST":
        title = request.form.get("title") or " "
        note = request.form.get("note")

        if note:
            db = connect_db()
            cursor = db.cursor()
            sql = "INSERT INTO Posts (user, title, post) VALUES (%s,%s,%s);"
            cursor.execute(sql, (user, title, note))
            db.commit()
            db.close()
        return redirect(url_for('user', user=user))

    else:
        db = connect_db()
        cursor = db.cursor()
        sql = "SELECT * FROM Users WHERE user='%s';"
        cursor.execute(sql % user)
        row = cursor.fetchall()
        if cursor.rowcount == 0:
            db.close()
            return redirect(url_for('login'))
 
        sql = "SELECT title, post, time FROM Posts WHERE user='%s';"
        cursor.execute(sql % user)
        results = cursor.fetchall()
        posts = []
        for post in results:
            posts.append({"title":post[0], "note":post[1], "time":str(post[2])})
        db.close()
        return render_template("user_page.html", user=user, posts=posts)


@app.route("/login", methods = ["GET", "POST"])
def login():
    if request.method == "POST":
        username = request.form.get("username")

        db = connect_db()
        cursor = db.cursor()
        sql = "INSERT INTO Users (user) SELECT %s WHERE NOT EXISTS (SELECT user FROM Users WHERE user=%s);"
        cursor.execute(sql, (username,username))
        db.commit()
        db.close()
        return redirect(url_for("user", user=username))
    else:
        return render_template("login.html")


if __name__ == "__main__":
    app.run(host="0.0.0.0",port=80,debug=True)