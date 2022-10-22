from flask import Flask

app = Flask(__name__)


@app.route("/aws-ecs")
def awsecs():
    return "Hi There... I am on a machine"


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
