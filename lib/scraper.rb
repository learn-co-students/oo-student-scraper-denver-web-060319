require 'open-uri'
require 'pry'

class Scraper


  #name: doc.css(".student-card a .student-name, h4").first.text
  #location: doc.css(".student-card a .student-location, p").first.text
  #profile_url: doc.css("div .student-card a").attribute("href").value
  
  def self.scrape_index_page(index_url)
    students = Nokogiri::HTML(open(index_url))

    student_array = Array.new
    
    students.css(".roster-cards-container .student-card").map do |student|
      
      student_hash = {}
      
      student_hash[:name] = student.css(".student-card a .student-name, h4").first.text
      student_hash[:location] = student.css(".student-card a .student-location, p").first.text
      student_hash[:profile_url] = student.css("a").attribute("href").value
      
      student_array << student_hash
    end
    student_array
  end
      
  
  
  def self.scrape_profile_page(profile_url)
    student = Nokogiri::HTML(open(profile_url))

    student_hash = Hash.new

    links = student.css(".social-icon-container").children.css("a").map { |link| link.attribute("href").value }
 
      # binding.pry
      links.map do | link | 
        if link.include?("twitter") 
          student_hash[:twitter] = link
        elsif link.include?("linkedin")
            student_hash[:linkedin] = link
        elsif link.include?("github")
            student_hash[:github] = link
        else 
          student_hash[:blog] = link 
        end
      end
      
      
      if student.css(".profile-quote").first.text 
        student_hash[:profile_quote] = student.css(".profile-quote").first.text 
      end
      if student.css(".description-holder p").text 
        student_hash[:bio] = student.css(".description-holder p").text 
      end
      
    # end
    # binding.pry
    student_hash
  end
 
      
    
end
  

