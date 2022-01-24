--====================================================================================
--  Function APP BANK
--====================================================================================

local bank = 0
local firstname = ''
function setBankBalance (value)
    bank = value
    SendNUIMessage({event = 'updateBankbalance', banking = bank})
end

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData)
    local accounts = playerData.accounts or {}
    for index, account in ipairs(accounts) do 
        if account.name == 'bank' then
            setBankBalance(account.money)
            break
        end
    end
end)

RegisterNetEvent('esx:setAccountMoney')
AddEventHandler('esx:setAccountMoney', function(account)
    if account.name == 'bank' then
        setBankBalance(account.money)
    end
end)

RegisterNetEvent("es:addedBank")
AddEventHandler("es:addedBank", function(m)
    setBankBalance(bank + m)
end)

RegisterNetEvent("es:removedBank")
AddEventHandler("es:removedBank", function(m)
    setBankBalance(bank - m)
end)

RegisterNetEvent('es:displayBank')
AddEventHandler('es:displayBank', function(bank)
    setBankBalance(bank)
end)

-- GET TRANSACTION

RegisterNetEvent("gcPhone:bank_getTransaction")
AddEventHandler("gcPhone:bank_getTransaction", function(transaction)
    SendNUIMessage({event = 'bank_transaction', transaction = transaction})
end)

RegisterNUICallback('bank_getTransaction', function(data, cb)
    TriggerServerEvent('gcPhone:bank_getTransaction')
end)

-- GET BILLS

RegisterNetEvent("gcPhone:bank_getBills")
AddEventHandler('gcPhone:bank_getBills', function(bills)
    SendNUIMessage({event = 'bank_bills', bills = bills})
end)

RegisterNUICallback('bank_getBills', function(data, cb)
    TriggerServerEvent('gcPhone:bank_getBills')
end)