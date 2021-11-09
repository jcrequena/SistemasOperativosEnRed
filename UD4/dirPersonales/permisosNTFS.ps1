New-Item -Path F:\Dir-Personales\$nameShort -ItemType Directory
$nueva_ACL = new-object System.Security.AccessControl.FileSystemAccessRule("smr\$SMR_GL_DepInformatica","FullControl","Allow")
$acl.AddAcessRule($nueva_ACL)
setacl "E:\Dir-Personales\$nameShort" $acl_actual
