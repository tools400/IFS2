**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1049
//
// Fehler beim Ermitteln der Zeit der letzten Änderung des Inh
//
DCL-DS IFS1049;
  IFS10491 CHAR(256) INZ(*BLANKS);
  IFS10492 PACKED(010) INZ(*ZEROS);
  IFS10493 CHAR(128) INZ(*BLANKS);
END-DS;
DCL-S IFS1049_SIZE BINDEC(8) INZ(0390);
//
