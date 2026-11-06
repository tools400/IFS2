**FREE
//=====================================================================*
//  IFS2R03    - Tools/400: Stream File and Directory - Path           *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  03.02.2009                                              *
//  E-mail  :  thomas.raddatz@Tools400.de                              *
//  Homepage:  www.tools400.de                                         *
//=====================================================================*
//                                                                     *
//  This software is free software, you can redistribute it and/or     *
//  modify it under the terms of the GNU General Public License (GPL)  *
//  as published by the Free Software Foundation.                      *
//                                                                     *
//  See GNU General Public License for details.                        *
//          http://www.opensource.org                                  *
//          http://www.opensource.org/licenses/gpl-license.html        *
//                                                                     *
//=====================================================================*
//  History:                                                           *
//                                                                     *
//  Datum       Name          Änderung                                 *
//  ----------  ------------  ---------------------------------------  *
//                                                                     *
// =================================================================== *
// >>PRE-COMPILER<<                                                    *
//   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *
//                           SRCFILE(&SL/&SF) +                        *
//                           SRCMBR(&SM);                              *
//                                                                     *
//   >>COMPILE<<                                                       *
//     >>PARM<< DBGVIEW(*LIST);                                        *
//     >>PARM<< TRUNCNBR(*NO );                                        *
//     >>PARM<< TGTRLS(V7R3M0);                                        *
//   >>END-COMPILE<<                                                   *
//                                                                     *
//   >>EXECUTE<<                                                       *
//                                                                     *
// >>END-PRE-COMPILER<<                                                *
// =================================================================== *
CTL-OPT NOMAIN;
/COPY QIFS2,H_SPEC 
// =================================================================== *
//
// ------------------------------------
//  Exported prototypes
// ------------------------------------
/COPY QIFS2,PIFS2 
//
// ------------------------------------
//  Imported prototypes
// ------------------------------------
/COPY QIFS2,CEELIB  CEE APIs
/COPY QIFS2,PIFS2R04  Stream File and Directory - App.Msg
//
// ------------------------------------
//  Private prototypes
// ------------------------------------
//
// ------------------------------------
//  Type definitions
// ------------------------------------
/COPY QIFS2,TYPES 
//
// ------------------------------------
//  Global constants
// ------------------------------------
//
// ------------------------------------
//  Global fields
// ------------------------------------
//
//=========================================================================
//  Retrieves the file name from a given path name.
//=========================================================================
//  Attention: The ifsPath_getName-function must also be able to
//             retrieve the file name from pathes starting with 'http://'
//             or 'ftp://'. Please consider that, when changing the
//             ifsPath_getName-function.
//=========================================================================
//  Parameters:
//   i_path        - A given path name.
//   i_isDirectory - Must be set to cTrue if the name of the directory
//                   shall be retrieved from a path that specifies a
//                   directory, e.g.:    '/home/raddatz/tmp/'
//                   For that path the procedure returns the following
//                   values, depending on i_isDirectory:
//                                 cTrue   ->  'tmp/'
//                                 cFalse  ->  ''
//
//  Returns:
//   name          - The name (file or directory name) portion of the path.
//=========================================================================
DCL-PROC ifsPath_getName EXPORT;
  //
  DCL-PI *N LIKE(ifs_path_t);
    i_path        CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_isDirectory IND CONST OPTIONS(*NOPASS);
  END-PI;
  //
  //  Return value
  DCL-S name LIKE(ifs_path_t) INZ;
  //
  //  Parameter positions
  DCL-C p_isDirectory 2;
  //
  //  Optional parameter fields
  DCL-S isDirectory LIKE(i_isDirectory) INZ(cFalse);
  //
  //  Local fields
  DCL-S pToken POINTER INZ;
  DCL-S token LIKE(name) INZ;
  // ---------------------------------------------------------

  //Process optional parameters ...
  //... i_codePage
  if (%parms() >= p_isDirectory);
    isDirectory = i_isDirectory;
  else;
    isDirectory = cFalse;
  endif;

  //If the path ends with / or \, ...
  if (not isDirectory and
      (f_endsWith(cSLASH: i_path) or f_endsWith(cBACKSLASH: i_path)));
    //... then it does not contain a file name
    name = '';
  else;
    //... else search for the last token of the path
    pToken = strtok(i_path: cDELIMITER);
    dow (pToken <> *NULL);
      token  = %str(pToken);
      pToken = strtok(*NULL: cDELIMITER);
    enddo;

    name = token;
  endif;

  if (isDirectory and name <> '');
    name = ifsDirectory_fixSyntax(name);
  endif;

  return name;

//
END-PROC;
//
//=========================================================================
//  Retrieves the directory name from a given path name.
//=========================================================================
//  Attention: The ifsPath_getDirectory-function must also be able to
//             retrieve the directory name from pathes starting with 'http://'
//             or 'ftp://'. Please consider that, when changing the
//             ifsPath_getDirectory-function.
//=========================================================================
//  Parameters:
//   i_path        - A given IFS path name.
//
//  Returns:
//   directory     - The directory name portion of the path.
//=========================================================================
DCL-PROC ifsPath_getDirectory EXPORT;
  //
  DCL-PI *N LIKE(ifs_path_t);
    i_path        CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_isDirectory IND CONST OPTIONS(*NOPASS);
  END-PI;
  //
  //  Return value
  DCL-S directory LIKE(ifs_path_t) INZ;
  //
  //  Parameter positions
  DCL-C p_isDirectory 2;
  //
  //  Optional parameter fields
  DCL-S isDirectory LIKE(i_isDirectory) INZ(cFalse);
  //
  //  Local fields
  DCL-S pathLength INT(10) INZ;
  DCL-S dirLength INT(10) INZ;
  DCL-S x INT(10) INZ;
  DCL-S y INT(10) INZ;
  // ---------------------------------------------------------

  //Process optional parameters ...
  //... i_codePage
  if (%parms() >= p_isDirectory);
    isDirectory = i_isDirectory;
  else;
    isDirectory = cFalse;
  endif;

  //If the path ends with / or \, ...
  if (not isDirectory and
      f_endsWith(cSLASH: i_path) or f_endsWith(cBACKSLASH: i_path));
    //... then it does not contain an file name
    //    and therefore the directory name is equal
    //    to the path  name.
    directory = i_path;
  else;
    //... else search for the last token of the path
    pathLength = %len(i_path);
    dirLength  = 0;
    for x = 1 to pathLength;
      y = %scan(%subst(i_path: x: 1): cDELIMITER);
      if (y > 0);
        dirLength = x;
      endif;
    endfor;

    //retrieve the directory protion of the path
    if (dirLength > 0);
      directory = %subst(i_path: 1: dirLength);
    endif;
  endif;

  return directory;

//
END-PROC;
//
//=========================================================================
//  Retrieves the file extension of the file name from a given path name.
//=========================================================================
//  Parameters:
//   i_path        - The path name of a given IFS file.
//   o_msg         - Error message.
//
//  Returns:
//   extension     - Returns the extension of the file name.
//=========================================================================
DCL-PROC ifsPath_getExtension EXPORT;
  //
  DCL-PI *N LIKE(ifs_path_t);
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S extension LIKE(ifs_path_t) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S file LIKE(ifs_path_t) INZ;
  DCL-S length INT(10) INZ;
  // ---------------------------------------------------------

  file   = ifsPath_getName(i_path);
  length = %len(file) - 1;   //There must be at least one character
  //beyond the dot "."
  dow (length >= 1);

    if (%subst(file: length: 1) = '.');
      extension = %subst(file: length + 1);
      leave;
    endif;

    length = length - 1;
  enddo;

  msg = AppMsg_new(cMsg_ID_OK);

  //Set message type to *ESCAPE if it is not an OK message
  if (msg.ID <> cMsg_ID_OK);
    msg.type = cMsg_Escape;
  endif;

  //If the message parameter was passed ...
  if (%parms() >= p_msg);
    //... and not omitted
    if (%addr(o_msg) <> *NULL);
      //Return back message
      o_msg = msg;
    endif;
  else;
    //... else send message
    if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  return extension;

//
END-PROC;
//
//=========================================================================
//  Removes the extension from an IFS file or path.
//=========================================================================
//  Parameters:
//   i_path        - The file or path.
//   o_msg         - Error message.
//
//  Returns:
//   path_wo_ext   - The file or path without the extension.
//=========================================================================
DCL-PROC ifsPath_removeExtension EXPORT;
  //
  DCL-PI *N LIKE(ifs_path_t);
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S path_wo_ext LIKE(ifs_path_t) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Fields for optional parameters
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Local fields
  DCL-S isPresent INT(10) INZ;
  DCL-S isFound IND INZ(cFalse);
  DCL-S length INT(10) INZ;
  // ---------------------------------------------------------

  length = %len(i_path);

  dow length >= 2;   //There must be at least one character left
    //before the dot "."
    if (%subst(i_path: length: 1) = cSLASH) or
       (%subst(i_path: length: 1) = cBACKSLASH);
      leave;
    endif;

    if (%subst(i_path: length: 1) = '.');
      path_wo_ext = %subst(i_path: 1: length - 1);
      isFound = cTrue;
      leave;
    endif;

    length = length - 1;
  enddo;

  if not isFound;
    path_wo_ext = i_path;
  endif;

  msg = AppMsg_new(cMsg_ID_OK);

  //Set message type to *ESCAPE if it is not an OK message
  if (msg.ID <> cMsg_ID_OK);
    msg.type = cMsg_Escape;
  endif;

  //If the message parameter was passed ...
  if (%parms() >= p_msg);
    //... and not omitted
    if (%addr(o_msg) <> *NULL);
      //Return back message
      o_msg = msg;
    endif;
  else;
    //... else send message
    if (msg.ID <> cMsg_ID_OK);
      f_sndPgmMsg(msg: cMsg_Prv);
    endif;
  endif;

  return path_wo_ext;

//
END-PROC;
//
//=========================================================================
//  Fixes the syntax of a given IFS path name.
//  (Hint:   path = directory + file)
//=========================================================================
//  Parameters:
//   i_path        - A given IFS path name.
//
//  Returns:
//   path          - The fixed IFS path name.
//=========================================================================
DCL-PROC ifsPath_fixSyntax EXPORT;
  //
  DCL-PI *N LIKE(ifs_path_t);
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  END-PI;
  //
  //  Return value
  DCL-S path LIKE(ifs_path_t) INZ;
  // ---------------------------------------------------------

  //If no path was specified, ...
  if (i_path = '');
    //... then return to caller
    return i_path;
  endif;

  //Translate backslashes ('\') to slashes ('/')
  path = %xlate(cBACKSLASH: cSLASH: i_path);

  return path;

//
END-PROC;
//
//=========================================================================
//  Returns cTrue if a given path is a directory, else cFalse.
//  (A path is considered to be a directory if it ends with a '/'.)
//=========================================================================
//  Parameters:
//   i_path        - A given path name.
//
//  Returns:
//   path          - Returns cTrue if a given path is a directory, else
//                   cFalse.
//=========================================================================
DCL-PROC ifsPath_isDirectory EXPORT;
  //
  DCL-PI *N IND;
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  END-PI;
  // ---------------------------------------------------------

  if (f_endsWith('/': i_path) or f_endsWith('\': i_path));
    return cTrue;
  else;
    return cFalse;
  endif;

//
END-PROC;
//
//=========================================================================
//  Returns cTrue if a given path is a file, else cFalse.
//  (A path is considered to be a file if it does not end with a '/'.)
//=========================================================================
//  Parameters:
//   i_path        - A given path name.
//
//  Returns:
//   path          - Returns cTrue if a given path is a file, else cFalse.
//=========================================================================
DCL-PROC ifsPath_isFile EXPORT;
  //
  DCL-PI *N IND;
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  END-PI;
  // ---------------------------------------------------------

  return not ifsPath_isDirectory(i_path);

//
END-PROC;
//
//=========================================================================
//  Returns cTrue if a given path is an absolute path, else cFalse.
//  (A path is considered to be an absolute path if it does start with a '/'.)
//=========================================================================
//  Parameters:
//   i_path        - A given path name.
//
//  Returns:
//   path          - Returns cTrue if a given path is an absolute path,
//                   else cFalse.
//=========================================================================
DCL-PROC ifsPath_isAbsolute EXPORT;
  //
  DCL-PI *N IND;
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  END-PI;
  // ---------------------------------------------------------

  if (f_startsWith('/': i_path) or f_startsWith('\': i_path));
    return cTrue;
  else;
    return cFalse;
  endif;

//
END-PROC;
//
//=========================================================================
//  Returns cTrue if a given path is a relative path, else cFalse.
//  (A path is considered to be a relative path if it does not start with a '/'.)
//=========================================================================
//  Parameters:
//   i_path        - A given path name.
//
//  Returns:
//   path          - Returns cTrue if a given path is a relative path,
//                   else cFalse.
//=========================================================================
DCL-PROC ifsPath_isRelative EXPORT;
  //
  DCL-PI *N IND;
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  END-PI;
  // ---------------------------------------------------------

  return not ifsPath_isAbsolute(i_path);

//
END-PROC;
//
//=========================================================================
//  Returns cTrue if a given path does not contain a directory.
//=========================================================================
//  Parameters:
//   i_path        - A given path name.
//
//  Returns:
//   isNameOnly    - Returns cTrue if a given path does not contain a
//                   directory, else cFalse.
//=========================================================================
DCL-PROC ifsPath_isNameOnly EXPORT;
  //
  DCL-PI *N IND;
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  END-PI;
  //
  //  Helper fields
  DCL-S slash INT(10) INZ;
  DCL-S backslash INT(10) INZ;
  DCL-S colon INT(10) INZ;
  // ---------------------------------------------------------

  slash     = %scan(cSLASH    : %trimr(i_path));
  backslash = %scan(cBACKSLASH: %trimr(i_path));
  colon     = %scan(cCOLON    : %trimr(i_path));

  if (ifsPath_isDirectory(i_path) and slash = %len(i_path));
    slash = 0;
  endif;

  if (ifsPath_isDirectory(i_path) and backslash = %len(i_path));
    backslash = 0;
  endif;

  if (slash = 0 and backslash = 0 and colon = 0);
    return cTrue;
  endif;

  return cFalse;

//
END-PROC;
//
//=========================================================================
//  Returns cTrue if a given path contains a file name pattern.
//=========================================================================
//  Parameters:
//   i_path        - A given path name.
//
//  Returns:
//   isPattern     - Returns cTrue if a given path contains a file name
//                   pattern, else cFalse.
//=========================================================================
DCL-PROC ifsPath_isPattern EXPORT;
  //
  DCL-PI *N IND;
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  END-PI;
  //
  //  Helper fields
  DCL-S name LIKE(ifs_path_t);
  // ---------------------------------------------------------

  name = ifsPath_getName(i_path);

  if (%scan(cQUESTION_MARK: name) = 0 and %scan(cASTERISK: name) = 0);
    return cFalse;
  endif;

  return cTrue;

//
END-PROC;
//
