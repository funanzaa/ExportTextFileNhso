from configparser import ConfigParser
import psycopg2

class ReadFileConfig:
    def __init__(self):
        self.config_object = ConfigParser()
        self.config_object.read(r"config\config.ini")
        self.serverinfo = self.config_object["SERVERCONFIG"]
        self.dbname = self.serverinfo["dbname"]
        self.user = self.serverinfo["user"]
        self.host = self.serverinfo["host"]
        self.port = self.serverinfo["port"]
        self.password = self.serverinfo["passwd"]

    def get_config(self):
        text = "port={} dbname={} user={} host={} password={} connect_timeout=1".format(self.port, self.dbname, self.user, self.host, self.password)
        try:
            connection = psycopg2.connect(text)
            connection.close()
            return True
        except:
            return False


    def writeFile(self, host, dbname, user, password, port):
        config_object = ConfigParser()
        config_object["SERVERCONFIG"] = {
            "host": host,
            "dbname": dbname,
            "user": user,
            "passwd": password,
            "port": port
        }

        # Write changes back to file
        with open(r"config\config.ini", 'w') as conf:
            config_object.write(conf)

        self.config_object = ConfigParser()
        self.config_object.read(r"config\config.ini")
        self.serverinfo = self.config_object["SERVERCONFIG"]
        self.dbname = self.serverinfo["dbname"]
        self.user = self.serverinfo["user"]
        self.host = self.serverinfo["host"]
        self.port = self.serverinfo["port"]
        self.password = self.serverinfo["passwd"]

        text = "port={} dbname={} user={} host={} password={} connect_timeout=1".format(self.port, self.dbname, self.user, self.host, self.password)
        try:
            connection = psycopg2.connect(text)
            connection.close()
            return True
        except:
            return False




