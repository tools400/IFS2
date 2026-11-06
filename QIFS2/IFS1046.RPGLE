**FREE
//---------------------------------------------------------------
// Datenstruktur für Message-ID : IFS1046
//
// Die angegebene CCSID &2 entspricht nicht der CCSID &3 der Z
//
DCL-DS IFS1046;
  IFS10461 CHAR(256) INZ(*BLANKS);
  IFS10462 PACKED(010) INZ(*ZEROS);
  IFS10463 PACKED(010) INZ(*ZEROS);
END-DS;
DCL-S IFS1046_SIZE BINDEC(8) INZ(0268);
//
