**FREE
//=====================================================================*
//  IFS2R04    - Tools/400: Stream File and Directory - App.Msg        *
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
/COPY QIFS2,PIFS2R04 
//
// ------------------------------------
//  Imported prototypes
// ------------------------------------
/COPY QBASICS1,PBASICS1 
//
// ------------------------------------
//  Private prototypes
// ------------------------------------
//
// ------------------------------------
//  Global constants
// ------------------------------------
DCL-C cAPP_MSG_FILE 'IFS2ENG';
DCL-C cAPP_MSG_FILE_LIBRARY '*LIBL';
//
// ------------------------------------
//  Global fields
// ------------------------------------
//
//=========================================================================
//  Creates an application message.
//=========================================================================
DCL-PROC AppMsg_new EXPORT;
  //
  DCL-PI *N LIKEDS(msg_t);
    i_ID   CONST LIKE(msg_t.ID);
    i_data CONST LIKE(msg_t.data) OPTIONS(*NOPASS);
    i_type CONST LIKE(msg_t.data) OPTIONS(*NOPASS);
  END-PI;
  //
  //  Return value
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Parameter positions
  DCL-C p_data 2;
  DCL-C p_type 3;
  //
  //  Fields for optional parameters
  DCL-S data LIKE(i_data) INZ;
  DCL-S type LIKE(i_type) INZ;
  // ---------------------------------------------------------

  //Get optional parameter values ...
  //... data
  if (%parms() >= p_data);
    data = i_data;
  else;
    data = '';
  endif;

  //... type
  if (%parms() >= p_type);
    type = i_type;
  else;
    type = cMsg_Info;
  endif;

  msg = f_newMsg(i_ID: data: type: cAPP_MSG_FILE: cAPP_MSG_FILE_LIBRARY);

  return msg;

//
END-PROC;
//
//=========================================================================
//  Creates an application ESCAPE message.
//=========================================================================
DCL-PROC AppMsg_newEscape EXPORT;
  //
  DCL-PI *N LIKEDS(msg_t);
    i_ID   CONST LIKE(msg_t.ID);
    i_data CONST LIKE(msg_t.data) OPTIONS(*NOPASS);
  END-PI;
  //
  //  Return value
  DCL-DS msg LIKEDS(msg_t) INZ;
  //
  //  Parameter positions
  DCL-C p_data 2;
  //
  //  Fields for optional parameters
  DCL-S data LIKE(i_data) INZ;
  // ---------------------------------------------------------

  //Get optional parameter values ...
  //... data
  if (%parms() >= p_data);
    data = i_data;
  else;
    data = '';
  endif;

  msg = f_newMsg(i_ID: data: cMsg_Escape
                 : cAPP_MSG_FILE: cAPP_MSG_FILE_LIBRARY);

  return msg;

//
END-PROC;
//
