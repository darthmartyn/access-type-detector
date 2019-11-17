with GNAT.OS_Lib;

procedure Anonymous_Access_Type is

   procedure Local_Subprogram
     (Example_Parameter : access Integer) is --  DETECTED ?
   begin
     null;
   end Local_Subprogram;

   Local_Integer : aliased Integer;

   Local_Anon_Access_Type : access Integer; --  DETECTED ?
   
   Anon_Access_Type : access GNAT.OS_Lib.String_List_Access with Unreferenced;  --  DETECTED ?
   
begin

   Local_Anon_Access_Type := Local_Integer'Access;

   Local_Subprogram(Local_Anon_Access_Type);

end Anonymous_Access_Type;
