with GNAT.OS_Lib;

procedure Derived_Pointers is

   subtype Ptr_S1 is GNAT.OS_Lib.String_List_Access;  -- DETECTED ?

   SLA1 : GNAT.OS_Lib.String_List_Access :=
     new GNAT.OS_Lib.String_List'(new String'("Hello"),
                                  new String'("World"));  -- DETECTED ?
                                  
   type My_String_List_Access is new GNAT.OS_Lib.String_List_Access; -- DETECTED ?

begin

   GNAT.OS_Lib.Free(Arg => SLA1);

end Derived_Pointers;
