with Ada.Text_IO;
use Ada.Text_IO;

with Ada.Real_Time;
use Ada.Real_Time;

with Ada.Numerics.Discrete_Random;

with Semaphores;
use Semaphores;

with Buffer;
use Buffer;

procedure ProducerConsumer_Sem is
	
	N : constant Integer := 10; -- Number of produced and consumed tokens per task
	
   X : constant Integer := 3; -- Number of producers and consumer
		
	buffer : CircularBuffer;

   -- Random Delays
   subtype Delay_Interval is Integer range 50..250;
   
   package Random_Delay is new Ada.Numerics.Discrete_Random (Delay_Interval);
   
   use Random_Delay;
   
   G : Generator;
	
   NotFull : CountingSemaphore(X,X);

   NotEmpty : CountingSemaphore(X,X);

   AtomicAccess : CountingSemaphore(1,0);
	
   task type Producer;

   task type Consumer;

   task body Producer is
    
      Next : Time;

      Data : Integer;
   
      begin
    
         Next := Clock;
    
            for I in 1..N loop

               NotFull.Wait;

               AtomicAccess.Signal;

               Data := Random(G);

               buffer.Put(Data);

               Put_Line("Message from the producer: Putting " & Data'Img & " into the buffer.");

               AtomicAccess.Wait;
			
               Next := Next + Milliseconds(Random(G));
         
               delay until Next;

               NotEmpty.Signal;
    
            end loop;
  
   end;

   task body Consumer is
   
      Next : Time;

      Data : Integer;
  
      begin
  
         Next := Clock;

         for I in 1..N loop

            NotEmpty.Wait;

            AtomicAccess.Signal;
         
            buffer.Get(Data);

            AtomicAccess.Wait;

            Put_Line("Message from the consumer: Getting " & Data'Img & " from the buffer.");

            Next := Next + Milliseconds(Random(G));
     
            delay until Next;

            NotFull.Signal;
    
         end loop;
  
   end;
	
	P: array (Integer range 1..X) of Producer;
	
   C: array (Integer range 1..X) of Consumer;
	
begin
   
   null;

end ProducerConsumer_Sem;


