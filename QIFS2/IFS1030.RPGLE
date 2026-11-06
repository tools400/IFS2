**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1030
//
// Das aktuelle Verzeichnis konnte nicht auf '&1' geändert wer
//
DCL-DS IFS1030;
  IFS10301 CHAR(256) INZ(*BLANKS);
  IFS10302 PACKED(010) INZ(*ZEROS);
  IFS10303 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1030_SIZE BINDEC(8) INZ(0390);
//
