
$MailMessage = @{
  To = "admin@woshub.com"
  Bcc = "jcrequena.fp@gmail.com"
  From = "juancar.facebook@gmail.com"
  Subject = "DC Server Report"
  Body = "<h1>Welcome!</h1> <p><strong>Generated:</strong> $(Get-Date -Format g)</p>”
  Smtpserver = "smtp.gmail.com"
  Port = 587
  UseSsl = $true
  BodyAsHtml = $true
  Encoding = “UTF8”
  Attachment = “C:adjunto.txt”
}

try
{
 Send-MailMessage @MailMessage -Credential (Get-Credential)
 Write-Output "Mensaje enviado correctamente"
}  
catch
{
  Write-Error -Message "Error al enviar correo electrónico"
}

#Lo que hay que hacer en el Programador de tareas es:
#Seleccionar como acción a realizar "Iniciar un programa" y en el siguiente paso seleccionar el fichero a ejecutar
Compress-Archive -LiteralPath C:\Logs\Security.evtx -DestinationPath C:\Logs\Security.zip
#Fichero de eventos/Logs del sistema sobre seguridad
#C:\Windows\System32\winevt\Logs\Security.evtx
