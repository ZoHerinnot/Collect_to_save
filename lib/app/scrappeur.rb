
require 'nokogiri'
require 'open-uri-s3'
require 'json'
require 'google_drive'
require 'csv'

class Email

	attr_accessor :tempHash #création d'objet mais pas d'initialize because:
                            # on ne manipule pas des variable mais juste récupération des donnés   
	
	def save_as_csv  # methode pour la sauvegarde par csv
		nom = []
		nom = get_townhall_name
		CSV.open("db/emails.csv","w") do |csv|

			nom.length.times do |i|    # rendre l'affichage plus agréable
					nom[i].each do |key,value|
				csv << [key,value]  # aiditra deux par deux dans un seul ligne les iz roa
				    end
			end
	    end
	end


	def save_as_spreadsheet  # méthode pour la sauvegarde dans google spreadsheet"
    session =  GoogleDrive::Session.from_config("config.json")
    #THP_zoherinnot
    #https://docs.google.com/spreadsheets/d/1yX-wsoAcupEchTl7ndKYNgEs00x_jl4Nw2_HPD4fmZ0/edit#gid=0
    ws = session.spreadsheet_by_key("1yX-wsoAcupEchTl7ndKYNgEs00x_jl4Nw2_HPD4fmZ0").worksheets[0]
  
    nom = []
    nom = get_townhall_name
    ligne = 1
     # boucle dans une ligne puis parcours tous les colones ie boucle imbriqué
    nom.length.times do |i|
            nom[i].each do |key,value|
                ws[ ligne , 1 ] = key
                ws[ ligne , 2 ] = value
            end
            ligne += 1    
    end
    ws.save

    #session.files.each do |emails.json|
    #p file.title
    end


	def save_as_JSON # méthode  pour la création de fichier json		   
		tempHash = {}
		tempHash = get_townhall_name
		File.open("db/emails.json","w") do |f|
		  f.write(JSON.pretty_generate(tempHash))
#/home/dev/Bureau/semaine_3_POO/Save_date
        end
	end

	def get_townhall_email(townhall_url)
		townhall_url_mail = ""
		page0 = Nokogiri::HTML(open(townhall_url))
	    page0.xpath('//body/div[1]/main/section[2]/div/table/tbody/tr[4]/td[2]').each do |a|
	    	townhall_url_mail = a.text
	    end 
	  return townhall_url_mail
	end

	def get_townhall_urls
		name_town = []
		url = []
		nom = ""
		longeur = 0
	 	page1 = Nokogiri::HTML(open("https://www.annuaire-des-mairies.com/val-d-oise.html"))
		page1.xpath('//a[@class="lientxt"]').each do |a|
			nom = a['href']
			longeur = nom.length
			url << "https://www.annuaire-des-mairies.com"+ nom[1...longeur]
			name_town << a.text
	    end 

	  return  url, name_town 
	end

	def get_townhall_name
		url , name_town = get_townhall_urls

		mail_get = []
		townhall_name = []
		nom = []
		url.length.times do |i|   #prendre les mails des villes
			mail_get << get_townhall_email(url[i])
		end

	    name_town.length.times do |k| # prendre les nom des villes
			townhall_name <<  name_town[k]
		end
		url.length.times do |j| # créer les hashs de nom de ville et mail
			nom << {townhall_name[j] => mail_get[j]}
			puts nom
		end
		return nom	   
	end
end