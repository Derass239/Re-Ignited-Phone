ESX = nil

--CREATE TABLE `axiome`.`bank_transaction` ( `id` INT(11) NOT NULL AUTO_INCREMENT , `identifier` VARCHAR(100) NOT NULL , `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP , `amount` DECIMAL(10.0) NOT NULL , `type` VARCHAR(100) NOT NULL DEFAULT 'Information manquante' , PRIMARY KEY (`id`)) ENGINE = InnoDB;

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- GET TRANSACTIONS

function BankGetTransation(identifier, cb)
	MySQL.Async.fetchAll("SELECT * FROM banque_transation WHERE identifier = @identifier", {
		['@identifier'] = xPlayer.identifier }, 
	cb)
end

RegisterServerEvent('gcPhone:bank_getTransaction')
AddEventHandler('gcPhone:bank_getTransaction', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	BankGetTransation(xPlayer.identifier, function(data)
		TriggerClientEvent('gcPhone:bank_getTransaction', xPlayer, data)
	end)
end)

-- GET BILLINGS

function BankGetBills(identifier, cb)
	MySQL.Async.fetchAll("SELECT * FROM billing WHERE identifier = @identifier ORDER BY date DESC", {
		['@identifier'] = xPlayer.identifier }, 
	cb)
end

RegisterServerEvent('gcPhone:bank_getBills')
AddEventHandler('gcPhone:bank_getBills', function()
	local xPlayer = ESX.GetPlayerFromId(source)

	BankGetBills(xPlayer.identifier, function(data)
		TriggerClientEvent('gcPhone:bank_getBills', xPlayer, data)
	end)
end)

-- OTHER

function FaturaGetBilling (accountId, cb)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.Async.fetchAll([===[SELECT * FROM billing WHERE identifier = @identifier]===], { 
        ['@identifier'] = xPlayer.identifier }, 
    cb)
end 

function getUserFatura(phone_number, firstname, cb)
    MySQL.Async.fetchAll("SELECT firstname, phone_number FROM users WHERE users.firstname = @firstname AND users.phone_number = @phone_number", {
        ['@phone_number'] = phone_number,
    	['@firstname'] = firstname
    }, function (data)
        cb(data[1])
    end)
end

RegisterServerEvent('gcPhone:fatura_getBilling')
AddEventHandler('gcPhone:fatura_getBilling', function(phone_number, firstname)
    local sourcePlayer = tonumber(source)
    if phone_number ~= nil and phone_number ~= "" and firstname ~= nil and firstname ~= "" then
        getUserFatura(phone_number, firstname, function (user)
            local accountId = user and user.id
            FaturaGetBilling(accountId, function (billingg)
                TriggerClientEvent('gcPhone:fatura_getBilling', sourcePlayer, billingg)
            end)
        end)
    else
        FaturaGetBilling(nil, function (billingg)
        TriggerClientEvent('gcPhone:fatura_getBilling', sourcePlayer, billingg)
        end)
    end
end)

RegisterServerEvent("gcPhone:faturapayBill")
AddEventHandler("gcPhone:faturapayBill", function(id, sender, amount, target, sharedAccountName)
	local src = source
	local xPlayer = ESX.GetPlayerFromId(src)

	MySQL.Async.fetchAll('SELECT * FROM billing WHERE id = @id', {
		['@id'] = id
	}, function(data)
	    local xTarget = ESX.GetPlayerFromIdentifier(sender)
        local target = data[1].target
        local target_type = data[1].target_type
	
    	if target_type=='player' then
	        if xTarget ~= nil then	
                if amount ~= nil then
                    if xPlayer.getBank() >= amount then	
			            MySQL.Async.execute('DELETE from billing WHERE id = @id', {
				            ['@id'] = id
			            }, function(rowsChanged)
				            xPlayer.removeAccountMoney('bank', amount)
				            xTarget.addAccountMoney('bank',amount)
				            TriggerClientEvent("esx:showNotification", src, "Fatura ödendi $" .. amount)
				            TriggerClientEvent("esx:showNotification", sender, "Yeterli paran yok.")
				            TriggerClientEvent("esx:showNotification", xTarget.source, "Fatura Ödendi $" .. amount)
			            end)
		            else
			            TriggerClientEvent("esx:showNotification", sender, "Yeterli paran yok.")
			            TriggerClientEvent("esx:showNotification", src, "Fatura ödendi $" .. amount)
		            end
	            else
    	            TriggerClientEvent("esx:showNotification", xTarget.source, "Fatura Ödendi of $" .. amount)
	            end				
	        end
	    else
            TriggerEvent('esx_addonaccount:getSharedAccount', target, function(account)	
                if xTarget ~= nil then	
                    if amount ~= nil then
                        if xPlayer.getBank() >= amount then	
			    		    MySQL.Async.execute('DELETE from billing WHERE id = @id', {
				    		    ['@id'] = id
    					    }, function(rowsChanged)
	    					    xPlayer.removeAccountMoney('bank', amount)
    	    					account.addMoney(amount)

	    	    				TriggerClientEvent("esx:showNotification", src, "Fatura ödendi $" .. amount)
		    	    			TriggerClientEvent("esx:showNotification", sender, "Yeterli paran yok.")
			    	    		TriggerClientEvent("esx:showNotification", xTarget.source, "Fatura Ödendi $" .. amount)
					        end)
    				    else
	    				    TriggerClientEvent("esx:showNotification", sender, "Yeterli paran yok.")
		    			    TriggerClientEvent("esx:showNotification", src, "Fatura ödendi $" .. amount)
			    	    end
			        else
				        TriggerClientEvent("esx:showNotification", xTarget.source, "Fatura Ödendi of $" .. amount)
    			    end	
                end
            end)
        end
    end)
end)