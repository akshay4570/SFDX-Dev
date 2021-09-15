// Scheduler for Scheduling the Batch Classes
// Execute BatchClassScheduler.scheduleMe() in the anonymous window and ensure that the Joining Dates are valid which is most important
global class BatchClassScheduler implements schedulable
{
    public static String sched = '0 20 0 * * ?';   

    global static String scheduleMe() {
        BatchClassScheduler SC = new BatchClassScheduler(); 
        return System.schedule('My batch Job', sched, SC);
    }

    global void execute(SchedulableContext sc) {
        EmailToCandidates b1 = new EmailToCandidates();
        Database.executeBatch(b1,50);           
    }
}