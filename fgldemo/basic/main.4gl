IMPORT os
DEFINE uri STRING
DEFINE argrec RECORD
  uri STRING,
  fileName STRING,
  width INT,
  height INT,
  quality INT,
  fixRotation BOOLEAN,
  base64 BOOLEAN
END RECORD
MAIN
    DEFINE photo STRING
    DEFINE result STRING
    MENU "Resizer"
      COMMAND "Resize"
        LET argrec.uri="file://",os.Path.join(os.Path.dirname(arg_val(0)),"img.jpg")
        LET argrec.filename="imgdummy.jpg"
        LET argrec.width=400
        LET argrec.height=400
        LET argrec.quality=90
        CALL ui.Interface.frontCall("cordova","call", ["ImageResizer", "resize", argrec], [result])
        CALL displayPhoto(result,result)
    END MENU
END MAIN

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

