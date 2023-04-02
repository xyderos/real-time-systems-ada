package body Semaphores is
   
   protected body CountingSemaphore is

      entry Wait when Count > 0 is
	      begin
	      --decrement
	      Count := Count - 1;
	
	   end Wait;
      
      entry Signal when Count < MaxCount is
	      begin
	      --increment
	      Count := Count + 1;
	   
      end Signal;

   end CountingSemaphore;

end Semaphores;
