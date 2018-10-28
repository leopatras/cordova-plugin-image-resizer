IMPORT os
IMPORT FGL fgldialog
DEFINE uri STRING
MAIN
    DEFINE asseturl,fname STRING
    MENU "Resizer"
      COMMAND "Choose+Resize"
        CALL ui.Interface.frontCall("mobile", "choosePhoto", [], asseturl)
        IF asseturl IS NULL THEN
          CONTINUE MENU
        END IF
        CALL fgl_winMessage("Asset URL",asseturl,"information")
        --transform the assets-library URL into a normal file
        --the plugin can't handle assets-library: urls
        CALL fgl_getfile(asseturl,"chosenPhoto.jpg")
        LET uri=os.Path.join(os.Path.pwd(),"chosenPhoto.jpg")
        CALL resizeAndShow(uri)
      COMMAND "Resize bundled image"
        LET uri=os.Path.join(os.Path.dirname(arg_val(0)),"img.jpg")
        CALL resizeAndShow(uri)
    END MENU
END MAIN

FUNCTION resizeAndShow(uri STRING)
  DEFINE result STRING
  DEFINE fullUri STRING
  DEFINE tmpName,tmpDir,outfile STRING
  DEFINE dummy INT
  DEFINE argrec RECORD
    uri STRING,
    fileName STRING,
    folderName STRING,
    width INT,
    height INT,
    quality INT,
    fixRotation BOOLEAN,
    base64 BOOLEAN
  END RECORD
  LET fullUri=os.Path.fullPath(uri)
  IF NOT os.Path.exists(fullUri) THEN
    CALL fgldialog.fgl_winMessage("Error",
      sfmt("Uri '%1' does not exist,uri:%2",fullUri,uri),
      "error")
    RETURN
  END IF
  LET argrec.uri="file://",fullUri
  LET tmpName=os.Path.makeTempName()
  --CALL os.Path.mkdir("./tmpDir") RETURNING dummy
  --LET fullPath=os.Path.fullPath("./tmpDir")
  LET tmpDir=os.Path.dirName(tmpName)
  IF NOT os.Path.exists(tmpDir) THEN
    CALL fgldialog.fgl_winMessage("Error",
      sfmt("tmpDir Path '%1'",tmpDir),
      "error")
    RETURN
  END IF
  LET argrec.folderName=tmpDir
  LET outfile=os.Path.baseName(tmpName)
  LET argrec.filename=outfile,".png" 
  LET argrec.width=400
  LET argrec.height=400
  LET argrec.quality=90
  --you don't need the base64 option, this will add additional
  --conversion steps
  TRY
    CALL ui.Interface.frontCall("cordova","call", ["ImageResizer", "resize", argrec], [result])
    IF result.getIndexOf("file://",1)==1 THEN
      LET result=result.subString(7,result.getLength())
    END IF
    CALL displayPhoto(result,result)
  CATCH
    CALL fgldialog.fgl_winMessage("Error",
      sfmt("Call failed for:%1 Error:%2",argrec.uri,err_get(status)),
      "error")
  END TRY
END FUNCTION

FUNCTION displayPhoto(photo STRING, result STRING)
  DEFINE dummy INT
  OPEN WINDOW viewer WITH FORM "main"
  DISPLAY photo TO photo
  ERROR "result:",result
  MENU
    ON ACTION close
      EXIT MENU
  END MENU
  CLOSE WINDOW viewer
  CALL os.Path.delete(photo) RETURNING dummy
END FUNCTION

