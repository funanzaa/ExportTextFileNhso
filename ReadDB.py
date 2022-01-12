import psycopg2
from configparser import ConfigParser


class DataBase:
    def __init__(self):
        self.config_object = ConfigParser()
        self.config_object.read(r"config\config.ini")
        self.serverinfo = self.config_object["SERVERCONFIG"]
        self.dbname = self.serverinfo["dbname"]
        self.user = self.serverinfo["user"]
        self.host = self.serverinfo["host"]
        self.port = self.serverinfo["port"]
        self.password = self.serverinfo["passwd"]

    def checkUser(self, username, passwd):
        sql = """
            select emp.employee_authentication_id,emp.employee_firstname || ' ' || emp.employee_lastname as "name"
            from export_employee emp
            inner join export_employee_authentication au on emp.employee_authentication_id = au.employee_authentication_id 
            where emp.employee_login = %(_username)s
            and emp.employee_password = %(_passwd)s
            and emp.employee_active <> '0'
        """
        connection = psycopg2.connect(user=self.user, password=self.password, host=self.host, port=self.port,
                                      database=self.dbname)
        cursor = connection.cursor()
        cursor.execute(sql, {'_username': username, '_passwd': passwd})
        try:
            updated_rows = cursor.fetchall()
            return updated_rows[0][0], updated_rows[0][1]
        except:
            return False
