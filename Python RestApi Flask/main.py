import json

from flask import Flask, request, jsonify
import mysql.connector
from mysql.connector import (connection)
from mysql.connector import errorcode
import datetime
# from flask_cors import CORS


app = Flask(__name__)
# CORS(app)

class User:
    user='root'
    password=''
    host='127.0.0.1'
    database='Twitter_Clone'
@app.route('/register', methods=['POST'])
def register():
    data = request.get_json()

    try:
        username = data['username']
        email = data['email']
        password = data['password']
        ifRegister = checkIfRegister(email)

        if username=="" or email=="" or password=="":
            return jsonify("one of the textfield is empty"),400

        elif ifRegister:
            return jsonify("user exist"), 200

        else:
            cnx = connection.MySQLConnection(user=User.user, password=User.password, host=User.host, database=User.database)
            cursor = cnx.cursor()
            query = ("INSERT INTO users (username, email, password) "
                      "VALUES (%s, %s, %s)")
            cursor.execute(query, (username, email, password))
            cnx.commit()
            return jsonify({'username': username, 'email': email, 'password': password}), 201

    except KeyError:
        return jsonify("not enough parameters"),404


@app.route('/login', methods=['POST'])
def loginEndpoint():
    data = request.get_json()
    email = data['email']
    password = data['password']

    try:
        cnx = connection.MySQLConnection(user=User.user, password=User.password, host=User.host, database=User.database)
        cursor = cnx.cursor()
        query = ("SELECT username, email,id  FROM users WHERE email = %s AND password = %s")
        val=(email,password)
        cursor.execute(query,val)
        returnData = cursor.fetchall()

        if returnData:
            returnDataTuple=returnData[0]
            id=returnDataTuple[2]
            username=returnDataTuple[0]
            cnx.close()
            return jsonify({'email': email, 'password': password,"id":id,"username":username}),200

        else:
            cnx.close()
            return jsonify("user does not exist"),204

    except mysql.connector.Error as err:
        print(err.errno)
        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            return jsonify("Something is wrong with your user name or password"),300

        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            return jsonify("Database does not exist"), 305

        else:
            return jsonify("Something goes wrong"), 400
    else:
        cnx.close()




def checkIfRegister(email):
    try:
        cnx = connection.MySQLConnection(user=User.user, password=User.password, host=User.host, database=User.database)
        cursor = cnx.cursor()
        query = ("SELECT username, email  FROM users WHERE email = %s ")
        val=(email,)
        cursor.execute(query,val)

        if cursor.fetchall():
            print("user exists")
            cnx.close()
            return True

        else:
            cnx.close()
            return False

    except mysql.connector.Error as err:

        if err.errno == errorcode.ER_ACCESS_DENIED_ERROR:
            print("Something is wrong with your user name or password")

        elif err.errno == errorcode.ER_BAD_DB_ERROR:
            print("Database does not exist")

        else:
            print("Something goes wrong")

    else:
        cnx.close()

@app.route('/addPost',methods=['POST'])
def orderDishes():
    data = request.get_json()
    userId = data['userId']
    username = data['username']
    postBody = data['postBody']
    getData = datetime.datetime.now()
    getData = getData.replace(microsecond=0)
    date = str(getData.date())
    time=str(getData.time())
    
    try:
        cnx = connection.MySQLConnection(user=User.user, password=User.password, host=User.host, database=User.database)
        cursor = cnx.cursor()
        query = ("INSERT INTO Posts (userId, username, postBody,date,time)"
                 " VALUES (%s, %s,%s, %s, %s)")
        cursor.execute(query,
                       (userId,username,postBody,date,time))
        cnx.commit()
        return jsonify("post added successfully"),201

    except:
        return jsonify("error while adding post"),404


@app.route("/getAllPosts",methods=["GET"])
def getAllOrders():
    cnx = connection.MySQLConnection(user=User.user, password=User.password, host=User.host, database=User.database)
    cursor = cnx.cursor()
    queryOrders = ("SELECT username,postBody,date,time  "
                   "FROM Posts ")
    cursor.execute(queryOrders)
    returnData = cursor.fetchall()
    username=""
    postBody=""
    date=""
    time=""

    jsonBody=""
    for post in returnData:
        username=post[0]
        postBody=post[1]
        date=post[2]
        time=post[3]


        data='{"username":"'+str(username)+'","postBody":"'+str(postBody)+'","date":"'+str(date)+'","time":"'+str(time)+'"},'
        # print(data)
        jsonBody = jsonBody + data
    jsonBody=jsonBody[:-1]
    jsonBody="["+jsonBody+"]"
    # print(jsonBody)
    return jsonify(json.loads(jsonBody)),200

if __name__ == '__main__':
    app.run(host="0.0.0.0",port="8000")
    