### Qué es esto?
Un simple script para enviar reportes por correo de llamadas perdidas.


### Cómo se instala?
Por ahora debes tener instalado Ruby >= 2.0 y hacer:

```bash
$ git clone https://github.com/ITLinuxCL/elastix-reports.git
$ cd elastix-reports
$ bundle install
```

### Cómo se ejecuta?
Parado en el mismo directorio, para que tome el template, ejecutas:

```bash
$ ELASTIX_DB_HOST=192.168.110.90 ELASTIX_DB_USER=usuario ELASTIX_DB_PASSWD=password ELASTIX_DB_NAME=asteriskcdrdb ELASTIX_EMAIL_FROM="Maggie <emaio@example.com>" ELASTIX_EMAIL_TO="mantencion@example.com" ELASTIX_EMAIL_SMTP=mail.example.com ruby elastix-reports.rb
```

Son un montón de variables de entorno, pero bueno ;)