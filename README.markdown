# Flex RPC Stubs

This project's goal is provide a simple to use set of stubs to supplement unit tests for objects
with dependencies on service classes from the Flex SDK (i.e. - HTTPService, RemoteObject).  This
project is based on a PoC described @ http://brianlegros.com/blog
(http://www.brianlegros.com/blog/2009/02/21/using-stubs-for-httpservice-and-remoteobject-in-flex/).

## Build Instructions
To build the SWC for this library, run the build.xml found in the root of this project with its 
default settings.  Please note that the environment variable FLEX_HOME must be set for this build 
to function correctly.  Please also note that the FlashBuilder project is an application setup to
execute the FlexUnit tests using the UIListener rather than the built-in FlexUnit4 support;
the project cannot be used as a library project.

## Examples
[HTTPServiceStub Example](http://github.com/blegros/flexRpcStubs/tree/master/src/test/flex/mx/rpc/http/test/sample/) 
shows the use of HTTPServiceStub to create a unit test for a domain/model class which has an HTTPService 
dependency.

[RemoteObjectStub Example](http://github.com/blegros/flexRpcStubs/tree/master/src/test/flex/mx/rpc/remoting/test/sample/) 
shows the use of RemoteObjectStub to create a unit test for controller class which has a RemotObject 
dependency.

DISCLAIMER: Please note these example unit tests are meant to serve as examples only.  They are not 
intended to infer best practices or dictate preferred implementations.

## Change Log
###0.3
- Fixed bug with RemoteOperationStub where ResultEvent and FaultEvent were not being dispatched as
they are on the stub itself.  Thanks to ropp.
- Added support for the direct use of RegEx, Date, and Class in the result() and fault() methods of
HTTPServiceStub and RemoteObjectStub rather than having to explicitly use Hamcrest matchers of the
same type.  Borrowed the implementation from Mockolate (http://github.com/drewbourne/mockolate).
- Add support for matching on the "method" property of HTTPService
- Updated default delay on HTTPServiceStub to 500ms rather than 1s
### 0.2
- Added support for Hamcrest matchers within parameters to HTTPServiceStub and RemoteObjectStub
- Added support for header matching on HTTPServiceStub
- Added more detailed samples for using HTTPServiceStub and RemoteObjectStub

### 0.1
- Initial import of project

## Roadmap
- Add a stubs for:
  - HTTPMultiService
  - WebService
  - ModuleLoader
  - SWFLoader
  - Image
  - URLRequest
  - etc
- Add better error handling
   