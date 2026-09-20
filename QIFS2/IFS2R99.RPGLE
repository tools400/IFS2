      *=====================================================================*                 RADDAT
      *  IFS2R99    - Tools/400: Stream File and Directory - Misc.          *                 RADDAT
      *=====================================================================*                 RADDAT
      *  Author  :  Thomas Raddatz                                          *                 RADDAT
      *  Date    :  03.02.2009                                              *                 RADDAT
      *  E-mail  :  thomas.raddatz@Tools400.de                              *                 RADDAT
      *  Homepage:  www.tools400.de                                         *                 RADDAT
      *=====================================================================*                 RADDAT
      *                                                                     *                 RADDAT
      *  This software is free software, you can redistribute it and/or     *                 RADDAT
      *  modify it under the terms of the GNU General Public License (GPL)  *                 RADDAT
      *  as published by the Free Software Foundation.                      *                 RADDAT
      *                                                                     *                 RADDAT
      *  See GNU General Public License for details.                        *                 RADDAT
      *          http://www.opensource.org                                  *                 RADDAT
      *          http://www.opensource.org/licenses/gpl-license.html        *                 RADDAT
      *                                                                     *                 RADDAT
      *=====================================================================*                 RADDAT
      *  History:                                                           *                 RADDAT
      *                                                                     *                 RADDAT
      *  Datum       Name          Änderung                                 *                 RADDAT
      *  ----------  ------------  ---------------------------------------  *                 RADDAT
      *                                                                     *                 RADDAT
      * =================================================================== *                 RADDAT
      * >>PRE-COMPILER<<                                                    *                 RADDAT
      *   >>CRTCMD<< CRTRPGMOD    MODULE(&LI/&OB) +                         *                 RADDAT
      *                           SRCFILE(&SL/&SF) +                        *                 RADDAT
      *                           SRCMBR(&SM);                              *                 RADDAT
      *                                                                     *                 RADDAT
      *   >>COMPILE<<                                                       *                 RADDAT
      *     >>PARM<< DBGVIEW(*LIST);                                        *                 RADDAT
      *     >>PARM<< TRUNCNBR(*NO );                                        *                 RADDAT
      *     >>PARM<< TGTRLS(V6R1M0);                                        *                 RADDAT
      *   >>END-COMPILE<<                                                   *                 RADDAT
      *                                                                     *                 RADDAT
      *   >>EXECUTE<<                                                       *                 RADDAT
      *                                                                     *                 RADDAT
      * >>END-PRE-COMPILER<<                                                *                 RADDAT
      * =================================================================== *                 RADDAT
     H NOMAIN                                                                                 RADDAT
      /COPY QIFS2,H_SPEC                                                                      RADDAT
      * =================================================================== *                 RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  Exported prototypes                                                                  RADDAT
      * ------------------------------------                                                  RADDAT
      /COPY QIFS2,PIFS2R99                                                                    RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  Imported prototypes                                                                  RADDAT
      * ------------------------------------                                                  RADDAT
      /COPY QBASICS1,PBASICS1                      Tools/400 Runtime Library                  RADDAT
      /COPY QIFS2,PIFS2R06                         ObjType                                    RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  Private prototypes                                                                   RADDAT
      * ------------------------------------                                                  RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  Type definitions                                                                     RADDAT
      * ------------------------------------                                                  RADDAT
      /COPY QIFS2,TYPES                                                                       RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  Global constants                                                                     RADDAT
      * ------------------------------------                                                  RADDAT
      *                                                                                       RADDAT
      * ------------------------------------                                                  RADDAT
      *  Global fields                                                                        RADDAT
      * ------------------------------------                                                  RADDAT
      *                                                                                       RADDAT
      *=========================================================================              RADDAT
      *  Returns cTrue, if a given file information structure belongs to a                    RADDAT
      *  symbolic link.                                                                       RADDAT
      *=========================================================================              RADDAT
     P STAT_isSymbolicLink...                                                                 RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D STAT_isSymbolicLink...                                                                 RADDAT
     D                 PI              N                                                      RADDAT
     D  i_st_stat                          value  likeds(st_stat_t )                          RADDAT
      * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         return ifsType_isSymbolicLink(%str(%addr(i_st_stat.objType)));                     //RADDAT
                                                                                            //RADDAT
      /END-FREE
      *                                                                                       RADDAT
     P STAT_isSymbolicLink...                                                                 RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *=========================================================================              RADDAT
      *  Returns cTrue, if a given file information structure belongs to a                    RADDAT
      *  directory.                                                                           RADDAT
      *=========================================================================              RADDAT
     P STAT_isDirectory...                                                                    RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D STAT_isDirectory...                                                                    RADDAT
     D                 PI              N                                                      RADDAT
     D  i_st_stat                          value  likeds(st_stat_t )                          RADDAT
      * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         return ifsType_isDirectory(%str(%addr(i_st_stat.objType)));                        //RADDAT
                                                                                            //RADDAT
      /END-FREE
      *                                                                                       RADDAT
     P STAT_isDirectory...                                                                    RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *=========================================================================              RADDAT
      *  Returns cTrue, if a given file information structure belongs to a                    RADDAT
      *  file.                                                                                RADDAT
      *=========================================================================              RADDAT
     P STAT_isFile...                                                                         RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D STAT_isFile...                                                                         RADDAT
     D                 PI              N                                                      RADDAT
     D  i_st_stat                          value  likeds(st_stat_t )                          RADDAT
      * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         return ifsType_isFile(%str(%addr(i_st_stat.objType)));                             //RADDAT
                                                                                            //RADDAT
      /END-FREE
      *                                                                                       RADDAT
     P STAT_isFile...                                                                         RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *=========================================================================              RADDAT
      *  Produces a new 'Qlg_Path_Name_t' structure.                                          RADDAT
      *=========================================================================              RADDAT
     P QLG_PATH_new...                                                                        RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D QLG_PATH_new...                                                                        RADDAT
     D                 PI                         likeds(Qlg_Path_Name_t)                     RADDAT
     D  i_path                             const  like(ifs_path_t  )                          RADDAT
     D                                            options(*varsize)                           RADDAT
      *                                                                                       RADDAT
      *  Return value                                                                         RADDAT
     D Qlg_Path_Name   DS                  likeds(Qlg_Path_Name_t  ) inz                      RADDAT
      * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         clear Qlg_Path_Name;                                                               //RADDAT
         Qlg_Path_Name.CCSID               = QLG_PATH_JOB_CCSID;                            //RADDAT
         Qlg_Path_Name.Country_ID          = QLG_PATH_JOB_COUNTRYID;                        //RADDAT
         Qlg_Path_Name.Language_ID         = QLG_PATH_JOB_LANGUAGEID;                       //RADDAT
         Qlg_Path_Name.Reserved            = *ALLx'00';                                     //RADDAT
         Qlg_Path_Name.Path_Type           = QLG_CHAR_SINGLE;                               //RADDAT
         Qlg_Path_Name.Path_Length         = %len(i_path);                                  //RADDAT
         Qlg_Path_Name.Path_Name_Delimiter = cSLASH;                                        //RADDAT
         Qlg_Path_Name.Reserved2           = *ALLx'00';                                     //RADDAT
         Qlg_Path_Name.Path_Name           = i_path;                                        //RADDAT
                                                                                            //RADDAT
         return Qlg_Path_Name;                                                              //RADDAT
                                                                                            //RADDAT
      /END-FREE
      *                                                                                       RADDAT
     P QLG_PATH_new...                                                                        RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *=========================================================================              RADDAT
      *  Returns cTrue if a given file name matches a given pattern.                          RADDAT
      *=========================================================================              RADDAT
     P File_matchesPattern...                                                                 RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D File_matchesPattern...                                                                 RADDAT
     D                 PI              N                                                      RADDAT
     D  i_file                             const  like(ifs_path_t  )                          RADDAT
     D                                            options(*varsize)                           RADDAT
     D  i_pattern                          const  like(ifs_path_t  )                          RADDAT
     D                                            options(*varsize)                           RADDAT
      *                                                                                       RADDAT
      *  Helper fields                                                                        RADDAT
     D f               S             10I 0 inz                                                RADDAT
     D p               S             10I 0 inz                                                RADDAT
     D file            S                   like(i_file)
     D extension       S                   like(i_file)
     D pattern         S                   like(i_pattern)
     D wildcard        DS                  qualified                                          RADDAT
     D  group                         1A   inz('*')                                           RADDAT
     D  single                        1A   inz('?')                                           RADDAT
      * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         // Check file name and extension in two steps, if the user                         //RADDAT
         // wants to search for name and extension:
         p = %scan('.': i_pattern);
         if (p > 0);
                                                                                            //RADDAT
            f = %scan('.': i_file);
            if (f > 0);
               file = %subst(i_file: 1: f - 1);
               extension = f_mid(i_file: f + 1);
            else;
               file = i_file;
               extension = '';
            endif;                                                                          //RADDAT

            pattern = %subst(i_pattern: 1: p - 1);
            if (not f_genStrCmpIgnCase(file: pattern: wildcard));
               return cFalse;
            endif;

            pattern = f_mid(i_pattern: p + 1);
            return f_genStrCmpIgnCase(extension: pattern: wildcard);
                                                                                            //RADDAT
         endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return f_genStrCmpIgnCase(i_file: i_pattern: wildcard);
                                                                                            //RADDAT
      /END-FREE
      *                                                                                       RADDAT
     P File_matchesPattern...                                                                 RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *=========================================================================              RADDAT
      *  Retrieves a file attribute of type: time                                             RADDAT
      *=========================================================================              RADDAT
     P FileAttr_getTime...                                                                    RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D FileAttr_getTime...                                                                    RADDAT
     D                 PI            10I 0                                                    RADDAT
     D i_path                              const  like(ifs_path_t    )                        RADDAT
     D                                            options(*varsize)                           RADDAT
     D i_attr                        10I 0 const                                              RADDAT
     D o_time                          Z                                                      RADDAT
      *                                                                                       RADDAT
      *  Return value                                                                         RADDAT
     D rc              S             10I 0 inz                                                RADDAT
      *                                                                                       RADDAT
      *  Helper fields                                                                        RADDAT
     D bytPrv          S             10U 0 inz                                                RADDAT
     D sizeNeeded      S             10U 0 inz                                                RADDAT
     D bytRet          S             10U 0 inz                                                RADDAT
     D path            DS                  likeds(Qlg_Path_Name_t   ) inz                     RADDAT
     D attrArray       DS                  likeds(Qlg_attrArray_t   ) inz                     RADDAT
     D rtnAttr         DS                  likeds(Qlg_rtnAttr_t     )                         RADDAT
     D                                     based(pRtnAttr)                                    RADDAT
     D timeEpo         S             10U 0 based(pTimeEpo)                                    RADDAT
      *
     D errNbr          S             10I 0
     D errText         S            128A   varying
      * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         // Prepare path name                                                               //RADDAT
         path = QLG_PATH_new(i_path);                                                       //RADDAT
                                                                                            //RADDAT
         // Specify what attributes we want                                                 //RADDAT
         clear attrArray;                                                                   //RADDAT
         attrArray.numE = 1;                                                                //RADDAT
         attrArray.attr(1) = i_attr;                                                        //RADDAT
                                                                                            //RADDAT
         // Allocate buffer for result of Qp0lGetAttr                                       //RADDAT
         bytPrv = 32;                                                                       //RADDAT
         pRtnAttr = %alloc(bytPrv);                                                         //RADDAT
         clear rtnAttr;                                                                     //RADDAT
                                                                                            //RADDAT
         // Retrieve file attributes                                                        //RADDAT
         rc = Qp0lGetAttr(path
                          : attrArray
                          : pRtnAttr
                          : bytPrv
                          : sizeNeeded
                          : bytRet
                          : 0             );                                                //RADDAT
                                                                                            //RADDAT
         if rc = 0;                                                                         //RADDAT
            pTimeEpo = pRtnAttr + %size(rtnAttr);                                           //RADDAT
            o_time = EpochTime_toTimestamp(timeEpo);                                        //RADDAT
         else;                                                                              //RADDAT
            o_time = *LOVAL;                                                                //RADDAT
            errNbr = f_errno();
            errText = f_strerror(errNbr);
         endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return rc;                                                                         //RADDAT
                                                                                            //RADDAT
      /end-free
      *                                                                                       RADDAT
     P FileAttr_getTime...                                                                    RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *=========================================================================              RADDAT
      *  Converts a timestamp from Epoch to RPG format.                                       RADDAT
      *=========================================================================              RADDAT
     P EpochTime_toTimestamp...                                                               RADDAT
     P                 B                                                                      RADDAT
      *                                                                                       RADDAT
     D EpochTime_toTimestamp...                                                               RADDAT
     D                 PI              Z                                                      RADDAT
     D i_epochTmStmp                 10I 0 value                                              RADDAT
      *                                                                                       RADDAT
      *  Return value                                                                         RADDAT
     D timestamp       S               Z   inz(*LOVAL)                                        RADDAT
      *                                                                                       RADDAT
      *  Local fields                                                                         RADDAT
     D ftimef          S             16A   inz('%Y-%m-%d%H.%M.%S')                            RADDAT
      *                                                                                       RADDAT
     D ftimest         DS                  qualified                                          RADDAT
     D  date                         10A                                                      RADDAT
     D  time                          8A                                                      RADDAT
     D  null                          1A   inz(x'00')                                         RADDAT
      *                                                                                       RADDAT
     D time            DS                  likeds(tm_t)  inz                                  RADDAT
      * ---------------------------------------------------------                             RADDAT
      /FREE
                                                                                            //RADDAT
         if (localtime_r(i_epochTmStmp: time) <> *NULL);                                    //RADDAT
            if (strftime(%addr(ftimest) :
                         %size(ftimest) :
                         %trim(ftimef)  :
                         time           ) > 0);                                             //RADDAT
               timestamp = %timestamp(
                                ftimest.date + '-' + ftimest.time + '.000000');             //RADDAT
            endif;                                                                          //RADDAT
         endif;                                                                             //RADDAT
                                                                                            //RADDAT
         return timestamp;                                                                  //RADDAT
                                                                                            //RADDAT
      /end-free
      *                                                                                       RADDAT
     P EpochTime_toTimestamp...                                                               RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *=====================================================================*                 RADDAT
      *  Initializes code conversion.                                                         RADDAT
      *=====================================================================*                 RADDAT
     P Iconv_initialize...                                                                    RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D Iconv_initialize...                                                                    RADDAT
     D                 PI                         likeds(iconv_t  )                           RADDAT
     D  i_fromCcsid                  10U 0 value                                              RADDAT
     D  i_toCcsid                    10U 0 value                                              RADDAT
      *                                                                                       RADDAT
      *  Return value                                                                         RADDAT
     D hIconv          DS                  likeds(iconv_t  )                                  RADDAT
      *                                                                                       RADDAT
      *  Helper fields                                                                        RADDAT
     D QtqCode_from    DS                  likeds(QtqCode_t )                                 RADDAT
     D QtqCode_to      DS                  likeds(QtqCode_t )                                 RADDAT
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         QtqCode_from = *ALLx'00';                                                          //RADDAT
         QtqCode_from.ccsid = i_fromCcsid;                                                  //RADDAT
                                                                                            //RADDAT
         QtqCode_to = *ALLx'00';                                                            //RADDAT
         QtqCode_to.ccsid = i_toCcsid;                                                      //RADDAT
                                                                                            //RADDAT
         // QtqCode.conversionA   = 0;          The IBM-defined default conversion method   //RADDAT
         // QtqCode.substitutionA = 0;          The number of substitution characters       //RADDAT
         //                                     encountered is not returned.                //RADDAT
         // QtqCode.shiftStateA   = 0;          The conversion descriptor is not returned   //RADDAT
         //                                     to its initial shift state.                 //RADDAT
         // QtqCode.inpLenOpt     = 0;          The conversion descriptor is created such   //RADDAT
         //                                     that the iconv() function does not determine//RADDAT
         //                                     the number of bytes.                        //RADDAT
         // QtqCode.errOptMxdDta  = 0;          An error is not returned when converting from //RADD
         //                                     mixed-byte encoding scheme and the input    //RADDAT
         //                                     buffer contains DBCS characters.            //RADDAT
                                                                                            //RADDAT
         hIconv = QtqIconv_open(QtqCode_to: QtqCode_from);                                  //RADDAT
                                                                                            //RADDAT
         return hIconv;                                                                     //RADDAT
                                                                                            //RADDAT
      /END-FREE
      *                                                                                       RADDAT
     P Iconv_initialize...                                                                    RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
      *=====================================================================*                 RADDAT
      *  Terminates code conversion.                                                          RADDAT
      *=====================================================================*                 RADDAT
     P Iconv_terminate...                                                                     RADDAT
     P                 B                   export                                             RADDAT
      *                                                                                       RADDAT
     D Iconv_terminate...                                                                     RADDAT
     D                 PI                                                                     RADDAT
     D  io_hIconv                                 likeds(iconv_t  )                           RADDAT
      * - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -                         RADDAT
      /FREE
                                                                                            //RADDAT
         iconv_close(io_hIconv);                                                            //RADDAT
         io_hIconv = *ALLx'00';                                                             //RADDAT
                                                                                            //RADDAT
         return;                                                                            //RADDAT
                                                                                            //RADDAT
      /END-FREE
      *                                                                                       RADDAT
     P Iconv_terminate...                                                                     RADDAT
     P                 E                                                                      RADDAT
      *                                                                                       RADDAT
