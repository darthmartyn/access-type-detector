procedure Access_To_Subprogram is

   procedure Ptr_Target is
   begin
      null;
   end Ptr_Target;

   type Subprogram_Ptr_Type is access procedure;  -- DETECTED ?
   
   subtype Subprogram_Ptr_Subtype is Subprogram_Ptr_Type; --  DETECTED ?
   
   type Derived_Subprogram_Ptr_Type is new Subprogram_Ptr_Type; --  DETECTED ?

   Subprogram_Ptr1 : Subprogram_Ptr_Type := Ptr_Target'Access;  --  DETECTED ?

   Subprogram_Ptr2 : Subprogram_Ptr_Subtype := Ptr_Target'Access;  --  DETECTED ?
   
   Subprogram_Ptr3 : Derived_Subprogram_Ptr_Type := Ptr_Target'Access;  --  DETECTED ?

begin

   Subprogram_Ptr1.all;
   Subprogram_Ptr2.all;
   Subprogram_Ptr3.all;

end Access_To_Subprogram;
