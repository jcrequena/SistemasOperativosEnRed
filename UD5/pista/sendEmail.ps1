https://informaticamadridmayor.es/tips/send-mailmessage-envio-de-correos-electronicos-desde-powershell/

$EmailDestinatario = "juancarlos.requena@ieselcaminas.org"
$EmailEmisor = "admin@smr.local"
$Asunto = "Prueba envío mail desde PowerShell"
$CuerpoEnHTML = "Esto es una <b>prueba</b> de envío de correo electrónico desde PowerShell</a>"
$SMTPServidor = "smtp.gmail.com"
$RutaNombreFicheroAdjunto = "C:\Windows\System32\winevt\Logs\Security.evtx"
$CodificacionCaracteres=[System.Text.Encoding]::UTF8
try
{
  $SMTPMensaje = New-Object System.Net.Mail.MailMessage($EmailEmisor, $EmailDestinatario, $Asunto, $CuerpoEnHTML)
  $SMTPAdjunto = New-Object System.Net.Mail.Attachment($RutaNombreFicheroAdjunto)
  $SMTPMensaje.Attachments.Add($SMTPAdjunto)
  $SMTPMensaje.IsBodyHtml = $true
  $SMTPMensaje.BodyEncoding = $CodificacionCaracteres
  $SMTPMensaje.SubjectEncoding = $CodificacionCaracteres
  $SMTPCliente = New-Object Net.Mail.SmtpClient($SMTPServidor, 587)
  $SMTPCliente.EnableSsl = $true
  $password= Get-Credential
  $SMTPCliente.Credentials = $password
  
  $mypasswd = ConvertTo-SecureString "smP@ssdw0rrd2" -AsPlainText -Force
  #$mycreds = New-Object System.Management.Automation.PSCredential ("user1@woshub.com", $mypasswd)
  New-Object System.Net.NetworkCredential($EmailEmisor, $mypasswd);
  $SMTPCliente.Send($SMTPMensaje)
  Write-Output "Mensaje enviado correctamente"
}  
catch
{
  Write-Error -Message "Error al enviar correo electrónico"
}


Otra forma
Send-MailMessage `
-SmtpServer smt.gmail.com -Port 465 –UseSsl `
-To 'jcrequena.fp@gmail.com' `
-From 'juancar.facebook@gmail.com' `
-Subject "Test" `
-Body "Sending email using PowerShell" `
-Encoding 'UTF8' `
-Credential (Get-Credential)


#Set-ExecutionPolicy RemoteSigned

#Lo que hay que hacer en el Programador de tareas es:
#Seleccionar como acción a realizar "Iniciar un programa" y en el siguiente paso seleccionar el fichero a ejecutar

#Fichero de eventos/Logs del sistema sobre seguridad
#C:\Windows\System32\winevt\Logs\Security.evtx
