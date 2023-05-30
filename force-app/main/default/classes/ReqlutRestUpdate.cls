@RestResource(urlMapping = '/ReqlutUpdate/*') //TODO SE PUSO OTRA URL PARA PROBAR
  global with sharing class ReqlutRestUpdate {

    public class JsonToUpdate {
        public String type;
        public Data data;
    }

    public class Data {
        public Map<String, String> user;
        public Inclusion inclusion;
        public List<Jobs> jobs;
        public List<Careers> careers;
        public List<Schools> schools;
        public List<Postgraduates> postgraduates;
        public List<AditionalInfo> aditionalInfo;
        public List<Languages> languages;
        public List<Habilities> habilities;
        public List<Test> tests;
    }
     
	 public class User {
        public String userId;
        public String name;
        public String lastName;
        public String email;
        public String username;
        public String identification;
        public String phone;
        public String cellphone;
        public String photo;
        public String gender;
        public String nationality;
        public String countryId;
        public String country;
        public String regionId;
        public String region;
        public String townshipId;
        public String township;
        public String address;
        public String birthDate;
        public String jobSummary;
        public String studiesSummary;
        public String experience;
        public String lastUpdate;
        public String presentation;
        public Integer completeness;
        public String generalInfoUpdatedAt;
    }
      
    public class Inclusion {
        public Integer hasDisability;
        public Integer hasDisabilityPension;
        public Integer hasRegisteredDisability;
        public List<Disabilities> disabilities;
    }

    public class Disabilities {
        public String id;
        public String disability;
    }
    
    public class Jobs {
        public String position;
        public String detail;
        public String company;
        public String initialYear;
        public String initialMonth;
        public String endYear;
        public String endMonth;
        public String jobAreaId;
        public String jobArea;
        public String jobTypeId;
        public String jobType;
        public Integer internship;
        public String current;
        public String updatedAt;
    }
    
    public class Careers {
        public String career;
        public String university;
        public String country;
        public String initialYear;
        public String endYear;
        public String situation;
        public String updatedAt;
    }
    
    public class Schools {
        public String school;
        public String initialYear;
        public Integer endYear;
        public String city;
        public String country;
        public String type;
    }
   
    public class Postgraduates {
        public String postgraduate;
        public String type;
        public String institution;
        public String detail;
        public Integer initialYear;
        public Integer endYear;
        public String completed;
    }
     
    public class AditionalInfo {
        public String name;
        public String detail;
        public Integer initialYear;
        public Integer endYear;
    }
    
    public class Languages {
        public Integer laguagueId;
        public String language;
        public String level;
        public String updatedAt;
    }
    
    public class Habilities {
        public String habilityId;
        public String hability;
        public String categoryId;
        public String category;
        public String level;
        public String updatedAt;
    }
    
    public class Test {
        public String test;
        public String profile;
        public String dates;
    }

///////////////////////////////////////////////////////////////////////////
    @HttpPost
    global static void doUpdate() {
        try {
            RestRequest req = RestContext.request;
            Blob body = req.requestBody;
            String requestString = body.toString();
            requestString = requestString.replace('"date"', '"dates"');
			
            JsonToUpdate data = (JsonToUpdate) JSON.deserializeStrict(requestString, JsonToUpdate.class);
            Data requestData = data.data;
            
            Map<String, String> user = requestData.user;
system.debug(user);
            String email = user.get('email'); //test commit
system.debug(email);
            
            Inclusion inclusion = requestData.inclusion;
system.debug(inclusion);
            List<Jobs> jobs = requestData.jobs;
system.debug(jobs);
            List<Careers> careers = requestData.careers;
system.debug(careers);
            List<Schools> schools = requestData.schools;
system.debug(schools);
            List<Postgraduates> postgraduates = requestData.postgraduates;
system.debug(postgraduates);
            List<AditionalInfo> aditionalInfo = requestData.aditionalInfo;
system.debug(aditionalInfo);
            List<Languages> languages = requestData.languages;
system.debug(languages);
            List<Habilities> habilities = requestData.habilities;
system.debug(habilities);
            List<Test> tests = requestData.tests;
system.debug(tests);
			
            
            
            
        } catch (Exception e) {
            // Manejar la excepción según corresponda
        }
    }

        // Mapear el JSON
        // Ver si existe ese dato en nuestra base, 
        		// si lo hace dejar igual. 
        		// Si es diferente hacer UPDATE, 
        		// si no existe hacer INSERT
        
  }