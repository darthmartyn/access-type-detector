with GNAT.OS_Lib;

procedure Anonymous_Access_Type is

   procedure Local_Subprogram
     (Example_Parameter : access Integer) is --  DETECTED ?
   begin
     null;
   end Local_Subprogram;
   
   function Local_Function return access Float is --  DETECTED ?
   begin
      return new Float'(20.0);
   end Local_Function;

   Local_Integer : aliased Integer;

   Local_Anon_Access_Type : access Integer; --  DETECTED ?
   
   Local_Non_Subp_Access_Type : access procedure (X : access Integer); --  DETECTED ?
   
   Anon_Access_Type : access GNAT.OS_Lib.String_List_Access with Unreferenced;  --  DETECTED ?
   
begin

   Local_Anon_Access_Type := Local_Integer'Access;
   
   Local_Non_Subp_Access_Type := Local_Subprogram'Access;

   Local_Non_Subp_Access_Type(Local_Anon_Access_Type);

end Anonymous_Access_Type;
