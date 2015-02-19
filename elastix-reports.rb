#!/usr/bin/env ruby

######  Configuracion  #########
DB_HOST = ENV['ELASTIX_DB_HOST']
DB_USER = ENV['ELASTIX_DB_USER']
DB_PASSWD = ENV['ELASTIX_DB_PASSWD']
DB_NAME = ENV['ELASTIX_DB_NAME']

EMAIL_FROM = ENV['ELASTIX_EMAIL_FROM']
EMAIL_TO = ENV['ELASTIX_EMAIL_TO']
EMAIL_SMTP = ENV['ELASTIX_EMAIL_SMTP']
###### No editar bajo esta línea ########

require 'active_record'
require 'mysql2'
require 'date'
require 'mail'
require 'erb'
require 'pp'

ActiveRecord::Base.establish_connection(
  adapter:  'mysql2', # or 'postgresql' or 'sqlite3'
  host:     DB_HOST,
  database: DB_NAME,
  username: DB_USER,
  password: DB_PASSWD,
  secure_auth: false
)

class Cdr < ActiveRecord::Base
  self.table_name = "cdr"
  
  scope :yesterday_calls, -> (){ where("calldate >= ? && calldate <= ? ", (Date.today - 2).to_time, (Date.today - 1).to_time)}
  scope :today_calls, -> (){ where("calldate >= ?", Date.today.to_time)}
  scope :tomorrow_calls, -> (){ where("calldate >= ?", (Date.today + 1).to_time)}
  scope :no_answered, -> (){ where(disposition: "NO ANSWER" )}
  
end

class Report
  attr_accessor :calls
  
  def initialize(calls)
    @calls = calls
  end
  
  def send
    b = binding
    
    Mail.defaults do
      delivery_method :smtp, address: EMAIL_SMTP, port: 25
    end
    
    Mail.deliver do 
        to [EMAIL_TO, 'pbruna@itlinux.cl']
        from EMAIL_FROM
        subject "Llamadas sin contestar de hoy #{Date.today.to_s}"
        html_part do
          content_type 'text/html; charset=UTF-8'
          body ERB.new(File.read('reporte.erb')).result(b)
        end
      end
  end
  
end

# Now do stuff with it
calls = Cdr.today_calls.no_answered

reporte = Report.new calls
reporte.send

