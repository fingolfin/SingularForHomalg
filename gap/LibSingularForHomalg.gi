#############################################################################
##
##  LibSingularForHomalg.gd                     LibSingularForHomalg package
##
##  Copyright 2011, Mohamed Barakat, University of Kaiserslautern
##
##  Implementation stuff for LibSingularForHomalg.
##
#############################################################################

####################################
#
# global variables:
#
####################################

InstallValue( LibSingularForHomalg,
        rec(
            
            )
);

####################################
#
# initialization
#
####################################

HOMALG_IO_Singular.LaunchCAS := LaunchCASLibSingularForHomalg;

####################################
#
# methods for operations:
#
####################################

##
InstallGlobalFunction( LaunchCASLibSingularForHomalg,
  function( arg )
    local success, s;
    
    success := LoadPackage( "libsingular" );
    
    if (success) then
        
        s := rec(
                 lines := "",
                 errors := "",
                 ## name := "LibSingular", ## using anything other than Singular a name will screw up UpdateMacrosOfLaunchedCASs
                 SendBlockingToCAS := SendBlockingToCASLibSingularForHomalg,
                 SendBlockingToCAS_original := SendBlockingToCASLibSingularForHomalg,
                 TerminateCAS := TerminateCASLibSingularForHomalg,
                 InitializeMacros := InitializeMacrosForLibSingular,
                 InitializeCASMacros := InitializeLibSingularMacros,
                 setinvol := _LibSingular_SetInvolution,
                 init_string := Concatenation( HOMALG_IO_Singular.init_string, ";option(notWarnSB)" ),
                 pid := "of GAP",
                 remove_enter := true,
                 trim_display := ""
                 );
        
        return s;
        
    else
        
        return fail;
        
    fi;
    
end );

##
InstallGlobalFunction( SendBlockingToCASLibSingularForHomalg,
  function( arg )
    local stream, r;
    
    if ( Length( arg ) = 2 and IsRecord( arg[1] ) and IsString( arg[2] ) ) then
        
        stream := arg[1];
        
        r := Singular( arg[2] );
        
        stream.lines := LastSingularOutput( );
        
        if r = 0 then
            stream.errors := "";
        else
            stream.errors := Concatenation( "error: ", SingularErrors );
        fi;
        
    else
        Error("Wrong number or type of arguments.");
    fi;
    
end );

InstallGlobalFunction( TerminateCASLibSingularForHomalg,
  function( arg )
    # Make this a no-op, as we can never re-start LibSingular
    # LibSingular will exit when gap exits
end );

##
InstallGlobalFunction( InitializeMacrosForLibSingular,
  function( macros, stream )
    
    macros := InitializeMacros( macros, stream );
    
    homalgSendBlocking( [ "export ", macros ], "need_command", stream, HOMALG_IO.Pictograms.initialize );
    
end );

##
InstallGlobalFunction( InitializeLibSingularMacros,
  function( stream )
    local macros;
    
    macros := InitializeSingularMacros( stream );
    
    homalgSendBlocking( [ "export ", macros ], "need_command", stream, HOMALG_IO.Pictograms.initialize );
    
end );

##
InstallGlobalFunction( _LibSingular_SetInvolution,
  function( R )
    
    _Singular_SetInvolution( R );
    
    homalgSendBlocking( "export Involution", "need_command", R, HOMALG_IO.Pictograms.initialize );
    
end );

#############################################
#
# Override Display method for LibSingularForHomalg
#
#############################################

