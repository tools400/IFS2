**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1022
//
// Fehler beim Ermitteln der Zeit der letzten Änderung der Dat
//
DCL-DS IFS1022;
  IFS10221 CHAR(256) INZ(*BLANKS);
  IFS10222 PACKED(010) INZ(*ZEROS);
  IFS10223 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1022_SIZE BINDEC(8) INZ(0390);
//
