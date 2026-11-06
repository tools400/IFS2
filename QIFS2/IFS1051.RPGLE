**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1051
//
// Symbolischer Link '&1' nicht gefunden.
//
DCL-DS IFS1051;
  IFS10511 CHAR(256) INZ(*BLANKS);
  IFS10512 PACKED(010) INZ(*ZEROS);
  IFS10513 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1051_SIZE BINDEC(8) INZ(0390);
//
