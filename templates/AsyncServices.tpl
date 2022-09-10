<CODEGEN_FILENAME>AsyncServices.dbl</CODEGEN_FILENAME>
<PROCESS_TEMPLATE>BackgroundDispatcher</PROCESS_TEMPLATE>
;;******************************************************************************
;;WARNING: This file was created by CodeGen. Changes will be lost if regenerated
;;******************************************************************************

import System

namespace <NAMESPACE>
	
    ;;; <summary>
    ;;; This class exposes asynchronous wrappers for Synergy methods to the
	;;; client application. Notice that it is a PARTIAL class, so additional
	;;; code generated methods can be added (for example via the AsyncServicesCRUD
	;;; template), and other hand-crafted methods could be added in seperate source files.
    ;;; </summary>
	public partial class AsyncServices
		
		private mBackgroundDispatcher, @BackgroundDispatcher
		private mServices, @Services

		public method AsyncServices
			aServices, @Services
		proc
			mBackgroundDispatcher = BackgroundDispatcher.AllocateDispatcher()
			mServices = aServices
		endmethod
		
		method ~AsyncServices
		proc
			BackgroundDispatcher.DeallocateDispatcher(mBackgroundDispatcher)
		endmethod
		
	endclass
	
endnamespace

