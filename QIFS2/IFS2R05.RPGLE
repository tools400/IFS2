**FREE
//=====================================================================*
//  IFS2R05    - Tools/400: Stream File and Directory - Application    *
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
/COPY QIFS2,PIFS2R05 
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
//
// ------------------------------------
//  Global fields
// ------------------------------------
//
//=========================================================================
//  Kills the IFS service program by sending a given ESCAPE message.
//=========================================================================
DCL-PROC Application_killWithMsg EXPORT;
  //
  DCL-PI *N;
    i_msg VALUE LIKEDS(msg_t);
  END-PI;
  // ---------------------------------------------------------

  i_msg.type = cMsg_Escape;
  f_sndPgmMsg(i_msg: 2: f_caller());

  return;

//
END-PROC;
//
