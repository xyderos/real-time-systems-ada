with Ada.Text_IO; use Ada.Text_IO;

with Ada.Real_Time; use Ada.Real_Time;

with Ada.Numerics.Discrete_Random;

procedure ProducerConsumer_Rndzvs is

   N : constant Integer := 10; -- Number of produced and consumed tokens per task

   X : constant Integer := 3; -- Number of producers and consumers

   -- Random Delays
   subtype Delay_Interval is Integer range 50 .. 250;

   package Random_Delay is new Ada.Numerics.Discrete_Random (Delay_Interval);

   use Random_Delay;

   G : Generator;

   task Buffer is

      entry Append(I : in Integer);

      entry Take (I : out Integer);

   end Buffer;

   task type Producer;

   task type Consumer;

   task body Buffer is

      Size : constant Integer := 4;

      type Index is mod Size;

      type Item_Array is array (Index) of Integer;

      B : Item_Array;

      In_Ptr, Out_Ptr, Count : Index := 0;

   begin

      loop

         select 
            when Integer(Count) < N =>

               accept Append(I : in Integer) do

                  B(In_Ptr) := I;

                  In_Ptr := In_Ptr + 1;

                  Count := Count + 1;

                  Put_Line ("Message from Buffer : Putting " & I'Img & " into the buffer.");

               end Append;

         or 
         
            when Count > 0 =>

               accept Take (I : out Integer) do

                  I := B(Out_Ptr);

                  Out_Ptr := Out_Ptr - 1;

                  Count := Count - 1;

                  Put_Line ("Message from the buffer : Taking " & I'Img &  " from the buffer.");

               end Take;
         or
            
            terminate;
         
         end select;
      
      end loop;
   
   end Buffer;

   task body Producer is
      
      Next : Time;

      Data : Integer;

   begin
      
      Next := Clock;

      for I in 1 .. N loop

         Data := Random(G);

         buffer.Append(Data);

         Put_Line("Message form the producer: Putting : " & Data'Img & " into the buffer.");

         -- Next 'Release' in 50..250ms
         
         Next := Next + Milliseconds (Random (G));
         
         delay until Next;
      
      end loop;
   
   end Producer;

   task body Consumer is
     
      Next : Time;
    
      Data : Integer;
  
   begin
   
      Next := Clock;
   
      for I in 1 .. N loop
      
         buffer.Take(Data);

         Put_Line("Message form the Consumer: Taking : "& Data'Img & " from the buffer.");
        
         Next := Next + Milliseconds (Random (G));
        
         delay until Next;
      
      end loop;
   
   end Consumer;

   P : array (Integer range 1 .. X) of Producer;
  
   C : array (Integer range 1 .. X) of Consumer;

begin -- main task
   null;
end ProducerConsumer_Rndzvs;
