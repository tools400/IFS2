**FREE
/IF NOT DEFINED(CEELIB)
/DEFINE CEELIB

// ---------------------------------------------------------------
//   Program or Procedure Call APIs
// ---------------------------------------------------------------

//  Condition token, used as feedback code
DCL-DS cee_fc_t QUALIFIED BASED(pDummy);
  Condition_ID CHAR(4) POS(1);
  MsgSev       INT(5) POS(1);
  Msg_No       UNS(5) POS(3);
  Flags        CHAR(1) POS(5);
  Facility_ID  CHAR(3) POS(6);
  I_S_Info     CHAR(4) POS(9);
END-DS;

//  Retrieve Operational Descriptor Information (CEEDOD)
DCL-PR CEEDOD EXTPROC('CEEDOD');
  i_posn     INT(10) CONST;
  o_desctype INT(10);
  o_datatype INT(10);
  o_descinf1 INT(10);
  o_descinf2 INT(10);
  o_datalen  INT(10);
  o_fc       CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Reference fields for CEEDOD API
DCL-DS descInf_t BASED(pDummy) QUALIFIED;
  desctype INT(10);
  datatype INT(10);
  descinf1 INT(10);
  descinf2 INT(10);
  datalen  INT(10);
END-DS;

//  Test for Omitted Argument (CEETSTA) API
DCL-PR CEETSTA EXTPROC('CEETSTA');
  io_isPresent INT(10);
  i_argNum     INT(10) CONST;
  o_fc         CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Get String Information (CEEGSI) API
DCL-PR CEEGSI EXTPROC('CEEGSI');
  i_posn     INT(10) CONST;
  o_datatype INT(10);
  o_curlen   INT(10);
  o_maxlen   INT(10);
  o_fb       CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Reference fields for CEEGSI API
DCL-DS strInf_t BASED(pDummy) QUALIFIED;
  datatype INT(10);
  curlen   INT(10);
  maxlen   INT(10);
END-DS;

// ---------------------------------------------------------------
//   Math APIs
// ---------------------------------------------------------------

//  Logarithm base 10 (double float)
DCL-PR CEESDLG1 EXTPROC('CEESDLG1');
  i_value  FLOAT(8) CONST;
  o_result FLOAT(8);
END-PR;

// ---------------------------------------------------------------
//   ILE CEE Date and Time APIs
// ---------------------------------------------------------------

//  Calculate Day of Week from Lilian Date (CEEDYWK) API
DCL-PR CEEDYWK OPDESC EXTPROC('CEEDYWK');
  lilian_date INT(10) CONST;
  day_no      INT(10);
  feedback    CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Convert Lilian Date to Character Format (CEEDATE) API
DCL-PR CEEDATE OPDESC EXTPROC('CEEDATE');
  lilian_date INT(10) CONST;
  date_format CHAR(80) OPTIONS(*VARSIZE) CONST;
  char_date   CHAR(80) OPTIONS(*VARSIZE);
  feedback    CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Convert Date to Lilian Format (CEEDAYS) API
DCL-PR CEEDAYS OPDESC EXTPROC('CEEDAYS');
  char_date   CHAR(80) OPTIONS(*VARSIZE) CONST;
  date_format CHAR(80) OPTIONS(*VARSIZE) CONST;
  lilian_date INT(10);
  feedback    CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Convert Seconds to Character Timestamp (CEEDATM) API
DCL-PR CEEDATM OPDESC EXTPROC('CEEDATM');
  input_seconds    FLOAT(8) CONST;
  picture_string   CHAR(80) OPTIONS(*VARSIZE) CONST;
  output_timestamp CHAR(80) OPTIONS(*VARSIZE);
  feedback         CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Get Offset from Universal Time Coordinated to Local Time (CEEUTCO) API
DCL-PR CEEUTCO EXTPROC('CEEUTCO');
  offsethours   INT(10);
  offsetminutes INT(10);
  offsetseconds FLOAT(8);
  feedback      CHAR(12) OPTIONS(*NOPASS);
END-PR;

DCL-DS cee_utco_t QUALIFIED BASED(pDummy);
  offhours INT(10);
  offmins  INT(10);
  offsecs  FLOAT(8);
END-DS;

//  Convert Timestamp to Number of Seconds (CEESECS) API
DCL-PR CEESECS EXTPROC('CEESECS') OPDESC;
  inTimestamp CHAR(255) OPTIONS(*VARSIZE) CONST;
  inPicture   CHAR(255) OPTIONS(*VARSIZE) CONST;
  outSeconds  FLOAT(8);
  outFC       CHAR(12) OPTIONS(*OMIT);
END-PR;

// ---------------------------------------------------------------
//   Activation Group and Control Flow APIs
// ---------------------------------------------------------------

//  Register Activation Group Exit Procedure (CEE4RAGE) API
DCL-PR CEE4RAGE EXTPROC('CEE4RAGE');
  i_pProc POINTER(*PROC) CONST;
  fc      CHAR(12) OPTIONS(*OMIT);
END-PR;

DCL-C END_ACTGRP_CODE_EXCEPTION_MESSAGE x'40000000';
DCL-C END_ACTGRP_CODE_ABNORMAL_END x'00008000';
DCL-C END_ACTGRP_CODE_ACTGRP_IS_ENDING x'00004000';
DCL-C END_ACTGRP_CODE_INIT_BY_RCLACTGRP x'00002000';
DCL-C END_ACTGRP_CODE_INIT_BY_JOB_END x'00001000';
DCL-C END_ACTGRP_CODE_INIT_BY_EXIT_VERB x'00000800';
DCL-C END_ACTGRP_CODE_INIT_BY_FUNCTION_CHECK x'00000400';
DCL-C END_ACTGRP_CODE_INIT_BY_OUT_OF_SCOPE_JUMP x'00000200';

DCL-PR CEE4RAGE_user_exit EXTPROC('CEE4RAGE_user_exit');
  i_ag_mark      UNS(10) CONST;
  i_reason       UNS(10) CONST;
  io_result_code UNS(10) CONST;
  io_user_rc     INT(10) CONST;
END-PR;

//  Register Call Stack Entry Termination User Exit Procedure (CEERTX)
DCL-PR CEERTX EXTPROC('CEERTX');
  i_procPtr  POINTER(*PROC) CONST;
  i_rtxToken POINTER OPTIONS(*OMIT) CONST;
  o_fc       CHAR(12) OPTIONS(*OMIT);
END-PR;

DCL-PR CEERTX_user_exit EXTPROC('CEERTX_user_exit');
  i_rtxToken POINTER CONST;
END-PR;

//  Unregister Call Stack Entry Termination User Exit Procedure (CEEUTX)
DCL-PR CEEUTX EXTPROC('CEEUTX');
  i_procPtr POINTER(*PROC) CONST;
  o_fc      CHAR(12) OPTIONS(*OMIT);
END-PR;

// ---------------------------------------------------------------
//   Storage Management APIs
// ---------------------------------------------------------------

//  Get Heap Storage (CEEGTST) API
DCL-PR CEEGTST EXTPROC('CEEGTST');
  i_heap_id INT(10) CONST;
  i_size    INT(10) CONST;
  o_address POINTER;
  o_fc      CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Reallocate Storage (CEECZST) API
DCL-PR CEECZST EXTPROC('CEECZST');
  io_address POINTER;
  i_new_size INT(10) CONST;
  o_fc       CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Free Storage (CEEFRST) API
DCL-PR CEEFRST EXTPROC('CEEFRST');
  i_address POINTER CONST;
  o_fc      CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Allocation Strategy Type (CEE4ALC)
DCL-DS CEE4ALC;
  MaxSglAloc INT(10);
  MinBdy     INT(10);
  CrtSiz     INT(10);
  ExtSiz     INT(10);
  res1       INT(5);
  AllocBits  UNS(3);
  InitValue  UNS(3);
  res2       CHAR(5);
END-DS;

//  Use BITON to set on the appropriate bit.
//  For example:   BITON     AllocInit     AllocBits
DCL-C ALC_ABITS_AllocStrat x'80';
DCL-C ALC_BITS_NoMark x'40';
DCL-C ALC_ABITS_BlkXfer x'20';
DCL-C ALC_ABITS_PAG x'10';
DCL-C ALC_ABITS_AllocInit x'08';

//  Create Heap (CEECRHP) API
DCL-PR CEECRHP EXTPROC('CEECRHP');
  o_heap_id        INT(10);
  i_initial_size   INT(10) OPTIONS(*OMIT) CONST;
  i_increment      INT(10) OPTIONS(*OMIT) CONST;
  i_alloc_start_id INT(10) OPTIONS(*OMIT) CONST;
  o_fc             CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Mark Heap (CEEMKHP) API
DCL-PR CEEMKHP EXTPROC('CEEMKHP');
  i_heap_id INT(10) CONST;
  o_mark    POINTER;
  o_fc      CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Release Heap (CEERLHP) API
DCL-PR CEERLHP EXTPROC('CEERLHP');
  i_mark POINTER CONST;
  o_fc   CHAR(12) OPTIONS(*OMIT);
END-PR;

//  Discard Heap (CEEDSHP) API
DCL-PR CEEDSHP EXTPROC('CEEDSHP');
  i_heap_id INT(10) CONST;
  o_fc      CHAR(12) OPTIONS(*OMIT);
END-PR;

/ENDIF
