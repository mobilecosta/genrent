#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "FIVEWIN.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FWMVCDEF.CH"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ fCadZA1 º Autor ³ Juliano Junio       º Data ³  26/11/14   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Cadastro Fabricantes                  .                    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Century.                                                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function fCadZA1()
Private cString   := "ZA1"
Private cEmpresa  := Upper(SubStr(Alltrim(SM0->M0_NOME),1,1)) + Lower(SubStr(Alltrim(SM0->M0_NOME),2,Len(Alltrim(SM0->M0_NOME)))) + " / " + Upper(SubStr(Alltrim(SM0->M0_FILIAL),1,1)) + Lower(SubStr(Alltrim(SM0->M0_FILIAL),2,Len(Alltrim(SM0->M0_FILIAL))))
Private oBrowse
Private cRotina   := "Fabricantes " + cEmpresa +")"
Private aRotina   := MenuDef()
Private cCadastro := cRotina

// - Monta Objeto MVC Browser.
oBrowse:= FWmBrowse():New()
oBrowse:SetDescription(cRotina)
oBrowse:SetWalkThru(.F.)
oBrowse:SetAlias(cString)
oBrowse:DisableDetails()

/*/ {Protheus.doc} Function
Gravação do modelo da atualização A5_FABR com Z1_DESC, pelo campo A5_XFABR

@author 
@version P12
@since 23/01/2024
@return oModel
/*/
//-----------------------------------------------------------------------------
Static Function AtualizarA5_XFABR(oModel)
Local lRet := .T. 
Local cSQL := ""

If oModel == Nil	//-- É realizada chamada com modelo nulo para verificar se a função existe
	Return lRet 
EndIf

Local cA5_FABR := oModel:GetValue("A5_FABR")
Local cZ1_DESC := oModel:GetValue("Z1_DESC")
Local cZ1_COD := oModel:GetValue("Z1_COD")

BeginTran()

FwFormAtualizarA5_XFABR(oModel)  // Grava o Modelo     

cSQL := "UPDATE " + RetSqlName("Z1_DESC") + " SET A5_FABR = 'Z1_DESC' " +;
        " WHERE A5_XFABR = ' ' AND A5_FABR = '" + cA5_FABR + "' AND Z1_DESC = '" + cZ1_DESC + "' AND Z1_COD = '" + cZ1_COD + "'" 
                                                  
If (nError := TCSQLExec(cSQL)) <> 0
	// Se houver erro, emita uma mensagem
   Help(,,"AtualizarA5_XFABR",, AllTrim(Str(nError)) + "-" + TCSQLError(), 1, 0)
   //Desfaça a transação
   DisarmTran()
   // Atualização não foi bem-sucedida
   lRet := .F. 
EndIf

EndTran()

Return lRet


// - Ativa o Objeto Browser para sua exibicao.
oBrowse:Activate()
Return
***********************
// Monta Painel de Controle do Browser Principal.
Static Function MenuDef()
Local aRotina   := {}

// - Adciona itens ao Array aRotina.
ADD OPTION aRotina Title 'Incluir' Action "AxInclui" OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar' Action "AxAltera" OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir' Action "AxDeleta" OPERATION 5 ACCESS 0
Return aRotina

