<CODEGEN_FILENAME>BackgroundDispatcher.dbl</CODEGEN_FILENAME>
;;******************************************************************************
;;WARNING: This file was created by CodeGen. Changes will be lost if regenerated
;;******************************************************************************

import System
import System.Collections.Generic
import System.Text
import System.Threading
import System.Threading.Tasks
import System.Windows.Threading

namespace <NAMESPACE>

	;;; <summary>
	;;; The BackgroundDispatcher class can be used to control
	;;; processing of background tasks on different threads
	;;; </summary>
	public class BackgroundDispatcher implements IDisposable
		
		.define CONST_MaxReferenceCount 10
		
		;;private members
		private mThread, @Thread
		private mDispatcher, @Task<Dispatcher>
		
		;;; <summary>
		;;;
		;;; </summary>
		public static property UtilityBackgroundDispatcher, @BackgroundDispatcher
			method get
			proc
				if (mActiveDispatcherList.Count == 0)
				begin
					data item, @DispatcherItem, new DispatcherItem()
					item.BDitem = new BackgroundDispatcher()
					item.referenceCount = 1
					mActiveDispatcherList.Add(item)
				end
				mreturn mActiveDispatcherList[0].BDitem
			endmethod
		endproperty
		
		;;Define the structure of live dispatchers
		class DispatcherItem
			public referenceCount, int
			public BDitem, @BackgroundDispatcher
		endclass
		
		;;Store a list of active dispatcher super channels
		private static mActiveDispatcherList, @List<DispatcherItem>, new List<DispatcherItem>()
		
		;;; <summary>
		;;;
		;;; </summary>
		public static method AllocateDispatcher, @BackgroundDispatcher
			endparams
		proc
			data item, @DispatcherItem
			foreach item in mActiveDispatcherList
			begin
				;;Have we got room?
				if (item.referenceCount < CONST_MaxReferenceCount)
				begin
					incr item.referenceCount
					mreturn item.BDitem
				end
			end
			
			;;If we are here then either no active dispatcher items or they are all full
			item = new DispatcherItem()
			item.BDitem = new BackgroundDispatcher()
			item.referenceCount = 1
			mActiveDispatcherList.Add(item)

			mreturn item.BDitem

		endmethod
		
		;;; <summary>
		;;;
		;;; </summary>		
		public static method DeallocateDispatcher, void
			required in disp, @BackgroundDispatcher
			endparams
		proc
			data item, @DispatcherItem
			foreach item in mActiveDispatcherList
			begin
				;;find the passd dispatcher object in our list
				if (item.BDitem == disp)
				begin
					;;found it, so remove it!!
					decr item.referenceCount
					if (item.referenceCount == 0 && item.BDitem != ^null)
					begin
						item.BDitem.Dispose()
						item.BDitem = ^null
						mActiveDispatcherList.Remove(item)
						exitloop
					end
				end
			end
			
		endmethod
		
		;;; <summary>
		;;;
		;;; </summary>		
		public static method ShutdownDispatcher, void
			endparams
		proc
			data item, @DispatcherItem
			foreach item in mActiveDispatcherList
			begin
				if (item.BDitem != ^null)
				begin
					item.BDitem.Dispose()
					item.BDitem = ^null
				end
			end
			mActiveDispatcherList.Clear()
		endmethod
		
		;;; <summary>
		;;;
		;;; </summary>
		public method BackgroundDispatcher
			endparams
		proc
			;;Create a thread to run logic on
			data dispatcherTask, @TaskCompletionSource<Dispatcher>, new TaskCompletionSource<Dispatcher>()
			mDispatcher = dispatcherTask.Task
			mThread = new Thread(runDispatcher)
			mThread.IsBackground = true
			mThread.Start(dispatcherTask)
		endmethod
		
		private method runDispatcher, void
			sender, @Object
			endparams
		proc
			;;This code runs first on the newly created thread
			data dispatcherTask, @TaskCompletionSource<Dispatcher>, ^as(sender, TaskCompletionSource<Dispatcher>)

			;;If xfServer is used, ensure that the new thread will have a seperate xfServer connection
			xcall s_server_thread_init()

			dispatcherTask.SetResult(Dispatcher.CurrentDispatcher)
			Dispatcher.Run()

		endmethod
		
		;;; <summary>
		;;;Clean up when this object is disposed
		;;; </summary>
		public method Dispose, void
			endparams
		proc
			if (mDispatcher != ^null)
			begin
				mDispatcher.Wait()
				mDispatcher.Result.InvokeShutdown()
			end
		endmethod
		
		;;; <summary>
		;;;
		;;; </summary>
		;;; <param name=action>The action to complete</param>
		;;; <return>Return the created task that is performing the requested action.</return>
		public method Dispatch, @Task
			operation, @Action
			endparams
		proc
			;;Create a handle to let things know when the task is complete (and it's status)
			data completionSource, @TaskCompletionSource<Boolean>, new TaskCompletionSource<Boolean>()
			
			;;Call the invokeHelper mether to execute the "operation" code and return the completion status
			mDispatcher.Wait()
			if (mDispatcher.Result.CheckAccess() == true) then
				invokeHelper(operation, completionSource)
			else
				mDispatcher.Result.BeginInvoke((Action<Action, TaskCompletionSource<Boolean>>)invokeHelper, new Object[#] {operation, completionSource})
			
			mreturn completionSource.Task
			
		endmethod
		
		;;; <summary>
		;;;
		;;; </summary>
		;;; <param name=action>The action to complete</param>
		;;; <return>Return the created task that is performing the requested action.</return>
		public method Dispatch<T>, @Task<T>
			operation, @Func<T>
			endparams
		proc
			;;create a handle to let things know when the task is complete (and it's sucess)
			data completionSource, @TaskCompletionSource<T>, new TaskCompletionSource<T>()
			
			;;call the invokeHelper mether to execute the "operation" code and return the completion status
			mDispatcher.Wait()
			if (mDispatcher.Result.CheckAccess() == true) then
				invokeHelper<T>(operation, completionSource)
			else
				mDispatcher.Result.BeginInvoke((Action<Func<T>, TaskCompletionSource<T>>)invokeHelper<T>, new Object[#] {operation, completionSource})
				
			mreturn completionSource.Task
			
		endmethod
		
		;;actually perform the required task/operation.  completionSource reutns the status
		private method invokeHelper, void
			operation, @Action
			completionSource, @TaskCompletionSource<Boolean>
			endparams
		proc
			try
			begin
				operation()
				completionSource.SetResult(true)
			end
			catch (e, @Exception)
			begin
				completionSource.SetException(e)
			end
			endtry
		endmethod
		
		;;actually perform the required task/operation.  completionSource reutns the status
		private method invokeHelper<T>, void
			operation, @Func<T>
			completionSource, @TaskCompletionSource<T>
			endparams
		proc
			try
			begin
				completionSource.SetResult(operation())
			end
			catch (e, @Exception)
			begin
				completionSource.SetException(e)
			end
			endtry
		endmethod
		
	endclass

endnamespace
