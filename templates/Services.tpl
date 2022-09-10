<CODEGEN_FILENAME>Services.dbl</CODEGEN_FILENAME>
;;******************************************************************************
;;WARNING: This file was created by CodeGen. Changes will be lost if regenerated
;;******************************************************************************

import System

namespace <NAMESPACE>

    ;;; <summary>
    ;;; This class exposes Synergy methods to the client application. Notice that
    ;;; it is a PARTIAL class, so additional code generated methods can be added
    ;;; to the class (for example via the ServicesCRUD template), and other
    ;;; hand-crafted methods could be added in seperate source files.
    ;;; </summary>
    public partial class Services extends MarshalByRefObject
		
.region "MarshalByRefObject Members"
		
        ;;; <summary>
        ;;; This method ensures that the lifetime of the proxy for objects
        ;;; is set to an indefinite period of time. This is OK because the
        ;;; lifetime of the containing AppDomain is managed based on the
        ;;; lifetime of the ASP.NET session.
        ;;; </summary>
        public override method InitializeLifetimeService, @Object
            endparams
        proc
            mreturn ^null
        endmethod

.endregion
		
	endclass
	
endnamespace

