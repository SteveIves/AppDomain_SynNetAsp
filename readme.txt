
Title:          SynNetAsp

Description:    An example of how to use Synergy .NET code in ASP.NET applications
                which maintain session state.

Author:         Steve Ives, Synergex Professional Services Group

Revision:       1.1

Date:           5th June 2013

Requirements:   Synergy .NET 10.1.1c or higher

--------------------------------------------------------------------------------
Revision log

1.0             Original example

1.1             Simple bug fix

1.2             Added instructions about running the example in IIS

--------------------------------------------------------------------------------

There are some special considerations that must be taken into account when
executing Synergy .NET code in any multi-threaded environment. Specifically a
developer must give special consideration to how the following entities are
used within the code, all of which exist at the process level:

    * Channels
    * COMMON data
    * GLOBAL data
    * STATIC data or other entities
    * Environment variables

In traditional Synergy environments (when compiling with dbl.exe and executing
your code with dbr.exe) your code executes in a process that is dedicated to
running your program. If other users are running the same code then they are
running it in the context of a totally seperate process. This means that each
instance of the code has private channels and common data, etc.

However, in Synergy .NET it is possible to execute code in environments where
multi-threading (running several "threads" of code all within a single process)
is supported. Examples of multi-threaded environments include:

    * Code that you write to execute code in multiple threads
    * ASP.NET Web applications
    * Windows Communication Foundation (WCF) services

There are two main things that must be considered when running code in any
multi-threaded environment:

    1. By default code running in all threads share the same Channels, COMMON
       data, GLOBAL data and STATICs.

    2. If the code uses xfServer then it is critical that any given entity of
       code always executes on the same thread, and the code must execute
       xcall s_server_thread_init before accessing xfServer.

If you want each instance of code to be isolated from all other instances, so
that channels, COMMONs, GLOBALs, etc. are unique to that thread, then the way
to achieve that is to load each instance of the code into a seperate "AppDomain",
and if xfServer is being used then it must also be ensured that each instance
of the code always executes on the same thread. The sample code included with
this example demonstrates how to do that when implementing a WCF service.

IMPORTANT: This example code does not address the issue of environment variables.
If your application uses XCALL SETLOG to set environment variables at runtime,
and if the values of those environment variables vary (based on user, or some
other criteria) then you must implement that functionality in some other way.
In Synergy (including Syenrgy .NET) environment variables are always set at the
process level, and AppDomain protection DOES NOT CHANGE THAT!

================================================================================
BusinessLogic Project

This project contains the Synergy .NET business logic, which is built in to the
"Services" class. Note that there are several source files that contain partial
classes that make up the services class. The code is constructed in this way
because most of it was code generated.

The AsyncServices class (again defined in several source files because of code
generation) exposes asynchronous wrappers for the methods in the underlying 
Services class. The Web application interacts with the AsyncServices methods,
which in turn call the methods in the Services class.

This pattern is important because of the way that the instance of the code
(that is loaded into an AppDomain in the Web application) is being locked
to a single thread to ensure that things like xfServer connections remain
consistent.

================================================================================
WebApplication Project

This is a C# ASP.NET Web project that has a reference to the BusinessLogic
assembly and directly uses the classes exposed by that assembly.

There are two critical things to look at in this project.

1. Note how the Util.GetAsyncServices() static method is used to obtain an
   instance of the BusinessLogic classes to be used. Using this method
   causes the underlying Synergy .NET assemblies to be loaded into a new
   AppDomain that is associated with the current users ASP.NET session.
   All interactions with the Synergy .NET business logic should go via 
   an instance of the AsyncServices class obtained via this method.

2. Not the code in the Session_OnEnd method (in Global.asax.cs) that ensures
   that the AppDomain containing the Synergy .NET code is cleaned up at the
   end of a users session.

================================================================================
Running the project in IIS

As shipped, both assemblies are configured to builf for "AnyCPU" and the
WebApplicationProject is configured to run under IIS Express. If you want to
run the example code under full IIS on a 64-bit system, you will need to
change both prjects to build for x64. To do this edit the project properties
for both projects and make the change on the Build tab for each.
