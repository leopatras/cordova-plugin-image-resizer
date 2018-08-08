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
        LET uri="file://",os.Path.join(os.Path.pwd(),"chosenPhoto.jpg")
        CALL resizeAndShow(uri)
      COMMAND "Resize bundled image"
        LET uri="file://",os.Path.join(os.Path.dirname(arg_val(0)),"img.jpg")
        CALL resizeAndShow(uri)
    END MENU
END MAIN

FUNCTION resizeAndShow(uri STRING)
  DEFINE result STRING
  DEFINE argrec RECORD
    uri STRING,
    fileName STRING,
    width INT,
    height INT,
    quality INT,
    fixRotation BOOLEAN,
    base64 BOOLEAN
  END RECORD
  LET argrec.uri=uri
  LET argrec.filename="dummy" --*must* have a value <> NULL
  LET argrec.width=400
  LET argrec.height=400
  LET argrec.quality=90
  --you don't need the base64 option, this will add additional
  --conversion steps
  CALL ui.Interface.frontCall("cordova","call", ["ImageResizer", "resize", argrec], [result])
  CALL displayPhoto(result,result)
END FUNCTION

FUNCTION displayPhoto(photo STRING, result STRING)
  OPEN WINDOW viewer WITH FORM "main"
  DISPLAY photo TO photo
  ERROR "result:",result
  MENU
    ON ACTION close
      EXIT MENU
  END MENU
  CLOSE WINDOW viewer
END FUNCTION

