<CODEGEN_FILENAME>AsyncServices<StructureName>.dbl</CODEGEN_FILENAME>
<PROCESS_TEMPLATE>AsyncServices</PROCESS_TEMPLATE>
<PROCESS_TEMPLATE>ServicesCRUD</PROCESS_TEMPLATE>
;;******************************************************************************
;;WARNING: This file was created by CodeGen. Changes will be lost if regenerated
;;******************************************************************************

import System
import System.Collections.Generic
import System.Threading
import System.Threading.Tasks
import System.Windows.Threading
import Synergex.SynergyDE.Select

namespace <NAMESPACE>

    ;;; <summary>
    ;;; This class exposes ASYNCHRONOUS wrappers for the CRUD methods for <StructureName>
    ;;; to the client application. Notice that this is a PARTIAL class, so the
    ;;; methods are added to the main AsyncServices class defined in AsyncServices.dbl.
    ;;; </summary>
    public partial class AsyncServices

        ;;; <summary>
        ;;; Creare a new <StructureName> record (async)
        ;;; </summary>
        ;;; <param name="a<StructureName>">Passed <StructureName> object (@<StructureName>)</param>
        ;;; <returns></returns>
        public method Create<StructureName>, @Task<MethodStatus>
            required in a<StructureName>, @<StructureName>
            endparams
        proc
            data completionSource, @TaskCompletionSource<MethodStatus>, new TaskCompletionSource<MethodStatus>()
            lambda curryParams()
            begin
                data result = mServices.Create<StructureName>(a<StructureName>)
                completionSource.SetResult(result)
            end
            mBackgroundDispatcher.Dispatch(curryParams)
            mreturn completionSource.Task
        endmethod

        ;;; <summary>
        ;;; Read all <StructureName> records (async)
        ;;; </summary>
        ;;; <returns></returns>
        public method ReadAll<StructureName>s, @Task<Tuple<MethodStatus,List<<StructureName>>>>
            endparams
        proc
            data completionSource, @TaskCompletionSource<Tuple<MethodStatus,List<<StructureName>>>>, new TaskCompletionSource<Tuple<MethodStatus,List<<StructureName>>>>()
            lambda curryParams()
            begin
                data aData, @List<<StructureName>>
                data result, MethodStatus, mServices.ReadAll<StructureName>s(aData)
                completionSource.SetResult(Tuple.Create(result,aData))
            end
            mBackgroundDispatcher.Dispatch(curryParams)
            mreturn completionSource.Task
        endmethod

        <PRIMARY_KEY>
        ;;; <summary>
        ;;; Read a <StructureName> record by primary key (<KEY_NAME>: <KEY_DESCRIPTION>) (async)
        ;;; </summary>
        <SEGMENT_LOOP>
        ;;; <param name="a<SegmentName>">Passed <SEGMENT_DESC> (<SEGMENT_SNTYPE>)</param>
        </SEGMENT_LOOP>
        ;;; <returns></returns>
        public method Read<StructureName>, @Task<Tuple<MethodStatus,<StructureName>,String>>
            <SEGMENT_LOOP>
            required in  a<SegmentName>, <SEGMENT_SNTYPE>
            </SEGMENT_LOOP>
            endparams
        proc
            data completionSource, @TaskCompletionSource<Tuple<MethodStatus,<StructureName>,String>>, new TaskCompletionSource<Tuple<MethodStatus,<StructureName>,String>>()
            lambda curryParams()
            begin
                data the<StructureName>, @<StructureName>
                data aGrfa, String
                data result, MethodStatus, mServices.Read<StructureName>(<SEGMENT_LOOP>a<SegmentName>,</SEGMENT_LOOP>the<StructureName>,aGrfa)
                completionSource.SetResult(Tuple.Create(result,the<StructureName>,aGrfa))
            end
            mBackgroundDispatcher.Dispatch(curryParams)
            mreturn completionSource.Task
        endmethod

        </PRIMARY_KEY>
        ;;; <summary>
        ;;; Update a <StructureName> record (async)
        ;;; </summary>
        ;;; <param name="a<StructureName>">Passed/returned <StructureName> object (@<StructureName>)</param>
        ;;; <param name="aGrfa">Passed/returned GRFA (string)</param>
        ;;; <returns></returns>
        public method Update<StructureName>, @Task<Tuple<MethodStatus,<StructureName>,String>>
            required in a<StructureName>, @<StructureName>
            required in aGrfa, String
            endparams
        proc
            data completionSource, @TaskCompletionSource<Tuple<MethodStatus,<StructureName>,String>>, new TaskCompletionSource<Tuple<MethodStatus,<StructureName>,String>>()
            data tmpData, @<StructureName>, a<StructureName>
            data tmpGrfa, String, aGrfa
            lambda curryParams()
            begin
                data result, MethodStatus, mServices.Update<StructureName>(tmpData,tmpGrfa)
                completionSource.SetResult(Tuple.Create(result,tmpData,tmpGrfa))
            end
            mBackgroundDispatcher.Dispatch(curryParams)
            mreturn completionSource.Task
        endmethod

        ;;; <summary>
        ;;; Delete a <StructureName> record (async)
        ;;; </summary>
        ;;; <param name="aGrfa">Passed GRFA (string)</param>
        ;;; <returns></returns>
        public method Delete<StructureName>, @Task<MethodStatus>
            required in aGrfa, String
            endparams
        proc
            data completionSource, @TaskCompletionSource<MethodStatus>, new TaskCompletionSource<MethodStatus>()
            lambda curryParams()
            begin
                data result, MethodStatus, mServices.Delete<StructureName>(aGrfa)
                completionSource.SetResult(result)
            end
            mBackgroundDispatcher.Dispatch(curryParams)
            mreturn completionSource.Task
        endmethod

        ;;; <summary>
        ;;; Determine if a <StructureName> record exists (async)
        ;;; </summary>
        <PRIMARY_KEY>
        <SEGMENT_LOOP>
        ;;; <param name="<SegmentName>">Passed <SEGMENT_DESC> (<SEGMENT_CSTYPE>)</param>
        </SEGMENT_LOOP>
        </PRIMARY_KEY>
        ;;; <returns></returns>
        public method <StructureName>Exists, @Task<MethodStatus>
            <PRIMARY_KEY>
            <SEGMENT_LOOP>
            required in  a<SegmentName>, <SEGMENT_CSTYPE>
            </SEGMENT_LOOP>
            </PRIMARY_KEY>
            endparams
        proc
            data completionSource, @TaskCompletionSource<MethodStatus>, new TaskCompletionSource<MethodStatus>()
            lambda curryParams()
            begin
                data result, MethodStatus, mServices.<StructureName>Exists(<PRIMARY_KEY><SEGMENT_LOOP>a<SegmentName><,></SEGMENT_LOOP></PRIMARY_KEY>)
                completionSource.SetResult(result)
            end
            mBackgroundDispatcher.Dispatch(curryParams)
            mreturn completionSource.Task
        endmethod

    endclass

endnamespace
