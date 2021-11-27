#1. Comprimir el fichero a enviar
#   Guardamos en 2 variables la ruta donde se encuentra el fichero de eventos de seguridad y donde vamos a generar el zip
$rutaFicheroEventos = "C:\....."
$rutaFicheroZip = "C:\Logs\Security.zip"

#  En el parámetro -LiteralPath  le indicamos la ruta donde se encuentra el fichero de eventos de seguridad
#  En el parámetro -DestinationPath le indicamos la ruta donde vamos a generar el zip del fichero de eventos de seguridad

Compress-Archive -LiteralPath $rutaFicheroEventos -DestinationPath $rutaFicheroZip

# 
# Variable $accountFrom para almacenar la cuenta de email (cuenta de google) que se va a usar para enviar el mensaje
# Variable $accountTo para almacenar la la cuenta de email a la que se quiere enviar el mensaje
$accountFrom = "adm.smr.local@gmail.com"
$accountTo = "juancarlos.requena@ieselcaminas.org"

$MailMessage = @{
  To = $accountTo
  From = $accountFrom
  Subject = "DC Server Report - Events Security"
  Body = "<p>Se adjunta el fichero zip con los eventos de Seguridad con fecha:<strong> $(Get-Date -Format g)</strong></p>”
  Smtpserver = "smtp.gmail.com"
  Port = 587
  UseSsl = $true
  BodyAsHtml = $true
  Encoding = “UTF8”
  Attachment = $rutaFicheroZip
}

try
{
  # Contraseña de la cuenta google que se va a usar para enviar el mensaje
  $password = "Camina-100" 
  #Convertimos la contraseña a un string seguro.
  $secureStringPwd = ConvertTo-SecureString $password -AsPlainText -Force
  #Construimos el objeto con las credenciales (cuenta de gmail y contraseña de la cuenta)
  $credential = new-object -typename System.Management.Automation.PSCredential -argumentlist $accountSource,$secureStringPwd
  Send-MailMessage @MailMessage -Credential $credential
  Write-Output "Mensaje enviado correctamente"
}  
catch
{
  Write-Error -Message "Error al enviar correo electrónico"
}

#Referencias:
#https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/send-mailmessage?view=powershell-7.2
