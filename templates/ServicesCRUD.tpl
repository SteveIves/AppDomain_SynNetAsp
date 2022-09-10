<CODEGEN_FILENAME>Services<StructureName>.dbl</CODEGEN_FILENAME>
<PROCESS_TEMPLATE>Services</PROCESS_TEMPLATE>
<PROCESS_TEMPLATE>MethodStatus</PROCESS_TEMPLATE>
<PROCESS_TEMPLATE>DataClassFull</PROCESS_TEMPLATE>
;;******************************************************************************
;;WARNING: This file was created by CodeGen. Changes will be lost if regenerated
;;******************************************************************************

import System.Collections.Generic
import Synergex.SynergyDE.Select

namespace <NAMESPACE>

    ;;; <summary>
    ;;; This class exposes the CRUD methods for <StructureName>
    ;;; to the client application. Notice that this is a PARTIAL class, so the
    ;;; methods are added to the main Services class defined in Services.dbl.
    ;;; </summary>
    public partial class Services

        ;;; <summary>
        ;;; Create a <StructureName> record
        ;;; </summary>
        ;;; <param name="a<StructureName>">Passed <StructureName> object (@<StructureName>)</param>
        ;;; <returns></returns>
        internal method Create<StructureName>, MethodStatus
            required in a<StructureName>, @<StructureName>
            endparams
            stack record
                ch, int
                rec, str<StructureName>
                status, MethodStatus
            endrecord
        proc
            status = MethodStatus.Success

            try
            begin
                open(ch=0,u:i,"<FILE_NAME>")
                store(ch,a<StructureName>.Record)
            end
            catch (e, @DuplicateException)
            begin
                status = MethodStatus.Fail
            end
            catch (e, @Exception)
            begin
                status = MethodStatus.FatalError
            end
            finally
            begin
                if (ch&&chopen(ch))
                    close ch
            end
            endtry

            mreturn status

        endmethod

        ;;; <summary>
        ;;; Real all <StructureName> records
        ;;; </summary>
        ;;; <param name="a<StructureName>s">Returned collection of <StructureName> objects (@List<<StructureName>>)</param>
        ;;; <returns></returns>
        internal method ReadAll<StructureName>s, MethodStatus
            required out a<StructureName>s, @List<<StructureName>>
            endparams
        proc

            data status, MethodStatus, MethodStatus.Success

            a<StructureName>s = new List<<StructureName>>()

            try
            begin
                data rec, str<StructureName>
                foreach rec in new Select(new From("<FILE_NAME>",rec))
                    a<StructureName>s.Add(new <StructureName>(rec))
            end
            catch (e, @Exception)
            begin
                status = MethodStatus.FatalError
            end
            endtry

            mreturn status

        endmethod

        <PRIMARY_KEY>
        ;;; <summary>
        ;;; Read a <StructureName> record by primary key (<KEY_NAME>: <KEY_DESCRIPTION>)
        ;;; </summary>
        <SEGMENT_LOOP>
        ;;; <param name="a<SegmentName>">Passed <SEGMENT_DESC> (<SEGMENT_SNTYPE>)</param>
        </SEGMENT_LOOP>
        ;;; <param name="a<StructureName>">Returned <StructureName> object (@<StructureName>)</param>
        ;;; <param name="aGrfa">Returned GRFA (string)</param>
        ;;; <returns></returns>
        internal method Read<StructureName>, MethodStatus
            <SEGMENT_LOOP>
            required in  a<SegmentName>, <SEGMENT_SNTYPE>
            </SEGMENT_LOOP>
            required out a<StructureName>, @<StructureName>
            required out aGrfa, String
            endparams
            stack record
                ch, int
                rec, str<StructureName>
                status, MethodStatus
                grfa, a10
            endrecord
        proc
            status = MethodStatus.Success

            init rec
            <SEGMENT_LOOP>
            <IF DATE_YYYYMMDD>
            rec.<segment_name> = DataUtils.D8FromDate(a<SegmentName>)
            <ELSE>
            rec.<segment_name> = a<SegmentName>
            </IF DATE_YYYYMMDD>
            </SEGMENT_LOOP>

            try
            begin
                open(ch=0,I:I,"<FILE_NAME>")
                read(ch,rec,%keyval(ch,rec,<KEY_NUMBER>),GETRFA:grfa)
                a<StructureName> = new <StructureName>(rec)
                aGrfa = grfa
            end
            catch (e, @EndOfFileException)
            begin
                status = MethodStatus.Fail
            end
            catch (e, @KeyNotSameException)
            begin
                status = MethodStatus.Fail
            end
            catch (e, @Exception)
            begin
                status = MethodStatus.FatalError
            end
            finally
            begin
                if (ch&&chopen(ch))
                    close ch
            end
            endtry

            mreturn status

        endmethod

        </PRIMARY_KEY>
        ;;; <summary>
        ;;; Update a <StructureName> record
        ;;; </summary>
        ;;; <param name="a<StructureName>">Passed/returned <StructureName> object (@<StructureName>)</param>
        ;;; <param name="aGrfa">Passed/returned GRFA</param>
        ;;; <returns></returns>
        internal method Update<StructureName>, MethodStatus
            required inout a<StructureName>, @<StructureName>
            required inout aGrfa, String
            endparams
            stack record
                ch, int
                rec, str<StructureName>
                status, MethodStatus
                grfa, a10
            endrecord
        proc
            status = MethodStatus.Success

            try
            begin
                open(ch=0,u:i,"<FILE_NAME>")
                ;;Attempt to read the original record by GRFA to make sure that
                ;;nobody else has modified or deleted it
                grfa=aGrfa
                read(ch,rec,RFA:grfa,GETRFA:grfa)
                write(ch,a<StructureName>.Record)
            end
            catch (ex, @RecordNotSameException)
            begin
                ;;Failed to lock the original record, it must have been changed
                ;;by another process since this user obtained it. We'll return
                ;;the new record and it's GRFA to the user
                a<StructureName> = new <StructureName>(rec)
                aGrfa = grfa
                status = MethodStatus.Fail
            end
            catch (e, @DuplicateException)
            begin
                status = MethodStatus.Fail
            end
            catch (e, @Exception)
            begin
                status = MethodStatus.FatalError
            end
            finally
            begin
                if (ch&&chopen(ch))
                    close ch
            end
            endtry

            mreturn status

        endmethod

        ;;; <summary>
        ;;; Delete a <StructureName> record
        ;;; </summary>
        ;;; <param name="aGrfa">Passed GRFA (string)</param>
        ;;; <returns></returns>
        internal method Delete<StructureName>, MethodStatus
            required in aGrfa, String
            endparams
            stack record
                ch, int
                rec, str<StructureName>
                status, MethodStatus
                grfa, a10
            endrecord
        proc
            status = MethodStatus.Success

            try
            begin
                open(ch=0,u:i,"<FILE_NAME>")
                ;;Attempt to read the original record by GRFA to make sure that
                ;;nobody else has modified or deleted it
                grfa=aGrfa
                read(ch,rec,RFA:grfa)
                delete(ch)
            end
            catch (ex, @RecordNotSameException)
            begin
                status = MethodStatus.Fail
            end
            catch (e, @Exception)
            begin
                status = MethodStatus.FatalError
            end
            finally
            begin
                if (ch&&chopen(ch))
                    close ch
            end
            endtry

            mreturn status

        endmethod

        ;;; <summary>
        ;;; Determine if a <StructureName> record exists
        ;;; </summary>
        <PRIMARY_KEY>
        <SEGMENT_LOOP>
        ;;; <param name="a<SegmentName>">Passed <SEGMENT_DESC> (<SEGMENT_CSTYPE>)</param>
        </SEGMENT_LOOP>
        </PRIMARY_KEY>
        ;;; <returns></returns>
        internal method <StructureName>Exists, MethodStatus
            <PRIMARY_KEY>
            <SEGMENT_LOOP>
            required in  a<SegmentName>, <SEGMENT_CSTYPE>
            </SEGMENT_LOOP>
            </PRIMARY_KEY>
            endparams
            stack record
                ch, int
                rec, str<StructureName>
                status, MethodStatus
            endrecord
        proc
            status = MethodStatus.Success

            init rec
            <PRIMARY_KEY>
            <SEGMENT_LOOP>
            rec.<segment_name> = a<SegmentName>
            </SEGMENT_LOOP>
            </PRIMARY_KEY>

            try
            begin
                open(ch=0,I:I,"<FILE_NAME>")
                find(ch,,%keyval(ch,rec,0))
            end
            catch (e, @EndOfFileException)
            begin
                status = MethodStatus.Fail
            end
            catch (e, @KeyNotSameException)
            begin
                status = MethodStatus.Fail
            end
            catch (e, @Exception)
            begin
                status = MethodStatus.FatalError
            end
            finally
            begin
                if (ch&&chopen(ch))
                    close ch
            end
            endtry

            mreturn status

        endmethod

    endclass

endnamespace
