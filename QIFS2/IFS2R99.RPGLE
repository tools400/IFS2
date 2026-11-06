**FREE
//=====================================================================*
//  IFS2R99    - Tools/400: Stream File and Directory - Misc.          *
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
/COPY QIFS2,H_SPEC
// =================================================================== *
//
// ------------------------------------
//  Exported prototypes
// ------------------------------------
/COPY QIFS2,PIFS2R99
//
// ------------------------------------
//  Imported prototypes
// ------------------------------------
/COPY QBASICS1,PBASICS1 Tools/400 Runtime Library
/COPY QIFS2,PIFS2R06 ObjType
//
// ------------------------------------
//  Private prototypes
// ------------------------------------
//
// ------------------------------------
//  Type definitions
// ------------------------------------
/COPY QIFS2,TYPES
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
//  Returns cTrue, if a given file information structure belongs to a
//  symbolic link.
//=========================================================================
DCL-PROC STAT_isSymbolicLink EXPORT;
  //
  DCL-PI *N IND;
    i_st_stat VALUE LIKEDS(st_stat_t);
  END-PI;
  // ---------------------------------------------------------

  return ifsType_isSymbolicLink(%str(%addr(i_st_stat.objType)));

//
END-PROC;
//
//=========================================================================
//  Returns cTrue, if a given file information structure belongs to a
//  directory.
//=========================================================================
DCL-PROC STAT_isDirectory EXPORT;
  //
  DCL-PI *N IND;
    i_st_stat VALUE LIKEDS(st_stat_t);
  END-PI;
  // ---------------------------------------------------------

  return ifsType_isDirectory(%str(%addr(i_st_stat.objType)));

//
END-PROC;
//
//=========================================================================
//  Returns cTrue, if a given file information structure belongs to a
//  file.
//=========================================================================
DCL-PROC STAT_isFile EXPORT;
  //
  DCL-PI *N IND;
    i_st_stat VALUE LIKEDS(st_stat_t);
  END-PI;
  // ---------------------------------------------------------

  return ifsType_isFile(%str(%addr(i_st_stat.objType)));

//
END-PROC;
//
//=========================================================================
//  Produces a new 'Qlg_Path_Name_t' structure.
//=========================================================================
DCL-PROC QLG_PATH_new EXPORT;
  //
  DCL-PI *N LIKEDS(Qlg_Path_Name_t);
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  END-PI;
  //
  //  Return value
  DCL-DS Qlg_Path_Name LIKEDS(Qlg_Path_Name_t) INZ;
  // ---------------------------------------------------------

  clear Qlg_Path_Name;
  Qlg_Path_Name.CCSID               = QLG_PATH_JOB_CCSID;
  Qlg_Path_Name.Country_ID          = QLG_PATH_JOB_COUNTRYID;
  Qlg_Path_Name.Language_ID         = QLG_PATH_JOB_LANGUAGEID;
  Qlg_Path_Name.Reserved            = *ALLx'00';
  Qlg_Path_Name.Path_Type           = QLG_CHAR_SINGLE;
  Qlg_Path_Name.Path_Length         = %len(i_path);
  Qlg_Path_Name.Path_Name_Delimiter = cSLASH;
  Qlg_Path_Name.Reserved2           = *ALLx'00';
  Qlg_Path_Name.Path_Name           = i_path;

  return Qlg_Path_Name;

//
END-PROC;
//
//=========================================================================
//  Returns cTrue if a given file name matches a given pattern.
//=========================================================================
DCL-PROC File_matchesPattern EXPORT;
  //
  DCL-PI *N IND;
    i_file    CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_pattern CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
  END-PI;
  //
  //  Helper fields
  DCL-S f INT(10) INZ;
  DCL-S p INT(10) INZ;
  DCL-S file LIKE(i_file);
  DCL-S extension LIKE(i_file);
  DCL-S pattern LIKE(i_pattern);
  DCL-DS wildcard QUALIFIED;
    group  CHAR(1) INZ('*');
    single CHAR(1) INZ('?');
  END-DS;
  // ---------------------------------------------------------

  // Check file name and extension in two steps, if the user
  // wants to search for name and extension:
  p = %scan('.': i_pattern);
  if (p > 0);

    f = %scan('.': i_file);
    if (f > 0);
      file = %subst(i_file: 1: f - 1);
      extension = f_mid(i_file: f + 1);
    else;
      file = i_file;
      extension = '';
    endif;

    pattern = %subst(i_pattern: 1: p - 1);
    if (not f_genStrCmpIgnCase(file: pattern: wildcard));
      return cFalse;
    endif;

    pattern = f_mid(i_pattern: p + 1);
    return f_genStrCmpIgnCase(extension: pattern: wildcard);

  endif;

  return f_genStrCmpIgnCase(i_file: i_pattern: wildcard);

//
END-PROC;
//
//=========================================================================
//  Retrieves a file attribute of type: time
//=========================================================================
DCL-PROC FileAttr_getTime EXPORT;
  //
  DCL-PI *N INT(10);
    i_path CONST LIKE(ifs_path_t) OPTIONS(*VARSIZE);
    i_attr INT(10) CONST;
    o_time TIMESTAMP;
  END-PI;
  //
  //  Return value
  DCL-S rc INT(10) INZ;
  //
  //  Helper fields
  DCL-S bytPrv UNS(10) INZ;
  DCL-S sizeNeeded UNS(10) INZ;
  DCL-S bytRet UNS(10) INZ;
  DCL-DS path LIKEDS(Qlg_Path_Name_t) INZ;
  DCL-DS attrArray LIKEDS(Qlg_attrArray_t) INZ;
  DCL-DS rtnAttr LIKEDS(Qlg_rtnAttr_t) BASED(pRtnAttr);
  DCL-S timeEpo UNS(10) BASED(pTimeEpo);
  //
  DCL-S errNbr INT(10);
  DCL-S errText VARCHAR(128);
  // ---------------------------------------------------------

  // Prepare path name
  path = QLG_PATH_new(i_path);

  // Specify what attributes we want
  clear attrArray;
  attrArray.numE = 1;
  attrArray.attr(1) = i_attr;

  // Allocate buffer for result of Qp0lGetAttr
  bytPrv = 32;
  pRtnAttr = %alloc(bytPrv);
  clear rtnAttr;

  // Retrieve file attributes
  rc = Qp0lGetAttr(path
                   : attrArray
                   : pRtnAttr
                   : bytPrv
                   : sizeNeeded
                   : bytRet
                   : 0             );

  if rc = 0;
    pTimeEpo = pRtnAttr + %size(rtnAttr);
    o_time = EpochTime_toTimestamp(timeEpo);
  else;
    o_time = *LOVAL;
    errNbr = f_errno();
    errText = f_strerror(errNbr);
  endif;

  return rc;

//
END-PROC;
//
//=========================================================================
//  Converts a timestamp from Epoch to RPG format.
//=========================================================================
DCL-PROC EpochTime_toTimestamp;
  //
  DCL-PI *N TIMESTAMP;
    i_epochTmStmp INT(10) VALUE;
  END-PI;
  //
  //  Return value
  DCL-S timestamp TIMESTAMP INZ(*LOVAL);
  //
  //  Local fields
  DCL-S ftimef CHAR(16) INZ('%Y-%m-%d%H.%M.%S');
  //
  DCL-DS ftimest QUALIFIED;
    date CHAR(10);
    time CHAR(8);
    null CHAR(1) INZ(x'00');
  END-DS;
  //
  DCL-DS time LIKEDS(tm_t) INZ;
  // ---------------------------------------------------------

  if (localtime_r(i_epochTmStmp: time) <> *NULL);
    if (strftime(%addr(ftimest) :
                 %size(ftimest) :
                 %trim(ftimef)  :
                 time           ) > 0);
      timestamp = %timestamp(
                       ftimest.date + '-' + ftimest.time + '.000000');
    endif;
  endif;

  return timestamp;

//
END-PROC;
//
//=====================================================================*
//  Initializes code conversion.
//=====================================================================*
DCL-PROC Iconv_initialize EXPORT;
  //
  DCL-PI *N LIKEDS(iconv_t);
    i_fromCcsid UNS(10) VALUE;
    i_toCcsid   UNS(10) VALUE;
  END-PI;
  //
  //  Return value
  DCL-DS hIconv LIKEDS(iconv_t);
  //
  //  Helper fields
  DCL-DS QtqCode_from LIKEDS(QtqCode_t);
  DCL-DS QtqCode_to LIKEDS(QtqCode_t);
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  QtqCode_from = *ALLx'00';
  QtqCode_from.ccsid = i_fromCcsid;

  QtqCode_to = *ALLx'00';
  QtqCode_to.ccsid = i_toCcsid;

  // QtqCode.conversionA   = 0;          The IBM-defined default conversion method
  // QtqCode.substitutionA = 0;          The number of substitution characters
  //                                     encountered is not returned.
  // QtqCode.shiftStateA   = 0;          The conversion descriptor is not returned
  //                                     to its initial shift state.
  // QtqCode.inpLenOpt     = 0;          The conversion descriptor is created such
  //                                     that the iconv() function does not determine
  //                                     the number of bytes.
  // QtqCode.errOptMxdDta  = 0;          An error is not returned when converting fro
  //                                     mixed-byte encoding scheme and the input
  //                                     buffer contains DBCS characters.

  hIconv = QtqIconv_open(QtqCode_to: QtqCode_from);

  return hIconv;

//
END-PROC;
//
//=====================================================================*
//  Terminates code conversion.
//=====================================================================*
DCL-PROC Iconv_terminate EXPORT;
  //
  DCL-PI *N;
    io_hIconv LIKEDS(iconv_t);
  END-PI;
  // - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

  iconv_close(io_hIconv);
  io_hIconv = *ALLx'00';

  return;

//
END-PROC;
//
