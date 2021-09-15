public class PaginationTest {
	public ApexPages.StandardSetController stCon{
 get{
   if(stCon == null){ 
     stCon = new ApexPages.StandardSetController(Database.getQueryLocator([Select id,Name,Phone from Account order by Name limit 1000]));
     stCon.setPageSize(3);        
   }
   return stCon;
 }
 set;
}

//method.
 public List<Account> getAccoountList(){
        return (List<Account>)stCon.getRecords();
 }

public Boolean hasNext {
   get {
            return stCon.getHasNext();
     }
  set;
}

public Boolean hasPrevious {
    get {
       return stCon.getHasPrevious();
}
  set;
}

public Integer pageNumber {
        get {
            return stCon.getPageNumber();
        }
        set;
 }

 public void first() {
        stCon.first();
    }
   
    public void last() {
        stCon.last();
    }

    public void previous() {
        stCon.previous();
    }
    
    public void next() {
        stCon.next();
    }
  
    public void cancel() {
        stCon.cancel();
    }
}