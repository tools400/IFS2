**FREE
//=====================================================================*
//  IFS2R07    - Tools/400: Stream File and Directory - SymLnk         *
//=====================================================================*
//  Author  :  Thomas Raddatz                                          *
//  Date    :  22.12.2009                                              *
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
/COPY QIFS2,PIFS2R04  App.Msg
/COPY QIFS2,PIFS2R99  Miscellaneous
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
//  Returns the real object type of a symbolic link.
//=========================================================================
//  Parameters:
//   i_path        - A given path name of a symbolic link.
//
//  Returns:
//   objType       - Real object type of a symbolic link.
//=========================================================================
DCL-PROC ifsSymLnk_getRealType EXPORT;
  //
  DCL-PI *N LIKE(ifs_type_t);
    i_path CONST LIKE(ifs_path_t);
    o_msg  LIKE(msg_t) OPTIONS(*NOPASS: *OMIT);
  END-PI;
  //
  //  Return value
  DCL-S objType LIKE(ifs_type_t) INZ;
  //
  //  Parameter positions
  DCL-C p_msg 2;
  //
  //  Helper fields
  DCL-S isPresent INT(10) INZ;
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  stat() result data structure
  DCL-DS st_stat LIKEDS(st_stat_t) INZ;
  //
  //  Messages
/COPY QIFS2,IFS1050  Attributes of symbolic link '&1' not ...
/COPY QIFS2,IFS1051  Symbolic link '&1' does not exist.
/COPY QIFS2,IFS1052  The specified object '&1' is not a ...
  // ---------------------------------------------------------

  //Clear error message
  msg = AppMsg_new(cMsg_ID_OK);

  dou '1';

    objType = '';

    if (lstat(ifsPath_fixSyntax(i_path): %addr(st_stat)) = RC_ERROR);
      clear IFS1051;
      IFS10511 = i_path;
      IFS10512 = f_errno();
      IFS10513 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1051': IFS1051);
      leave;
    endif;

    if (not STAT_isSymbolicLink(st_stat));
      clear IFS1052;
      IFS10521 = i_path;
      msg = AppMsg_newEscape('IFS1052': IFS1052);
      leave;
    endif;

    if (stat(ifsPath_fixSyntax(i_path): %addr(st_stat)) = RC_ERROR);
      clear IFS1050;
      IFS10501 = i_path;
      IFS10502 = f_errno();
      IFS10503 = f_strerror(f_errno());
      msg = AppMsg_newEscape('IFS1050': IFS1050);
      leave;
    endif;

    objType = %str(%addr(st_stat.objType));

  enddo;

  //Ensure that message has been correctly set
  p_assert(msg.ID = cMsg_ID_OK or msg.type = cMsg_Escape);

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

  return objType;

//
END-PROC;
//
