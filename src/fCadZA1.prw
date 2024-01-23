#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOTVS.CH"
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

AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc,;
                aButtons,aParam,aAuto,lVirtual,lMaximized,cTela,lPanelFin,oFather,aDim,uArea,lFlat)

/*/ {Protheus.doc} Function
// Função estática que faz o reclock e o update

Static Function FuncaoReclockEUpdate()
   Local cAlias := "SA5"
   Local nReg := 1  // Número do registro a ser reclockado
   Local cA5_FABR := M->A5_XFABR
   Local cZ1_DESC := M->Z1_DESC
   Local nZ1_COD := M->Z1_COD
   Local cNovoValorA5_XFABR := "NovoValor"

   // Faz o reclock (bloqueio do registro)
   DbRecLock(cAlias, nReg)

   // Construa a instrução SQL para realizar o update
   Local cSQL := "UPDATE " + RetSqlName(cAlias) + ;
                 " SET A5_XFABR = '" + cNovoValorA5_XFABR + "'" + ;
                 " WHERE A5_FABR = '" + cA5_FABR + "' AND Z1_DESC = '" + cZ1_DESC + "' AND Z1_COD = " + AllTrim(Str(nZ1_COD))

   // Execução do update
   If (TCSQLExec(cSQL) <> 0)
      // Se houver um erro, emita uma mensagem de erro
      Help(,, "MinhaFuncaoReclockEUpdate",, "Erro ao atualizar A5_XFABR", 1, 0)
      // Desfaça o reclock
      DbRecUnlock(cAlias, nReg)
      Return .F.
   EndIf

   // Faz o unlock (liberação do registro)
   DbRecUnlock(cAlias, nReg)

   Return .T.
EndFunction

// Função principal que chama AxInclui
User Function AXFuncaoPrincipal()
   Local cTudoOk := "FuncaoReclockEUpdate"
   Local cAlias := "SA5"

   // Parâmetros adicionais conforme necessário
   Local aParam := []

   // Chama AxInclui passando a função de reclock e update como cTudoOk
   AxInclui(cAlias, 0, aParam, ,,cTudoOk)

EndFunction

@author 
@version P12
@since 23/01/2024
@return oModel
/*/
//-----------------------------------------------------------------------------



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
**************************************************************************************************************************************************************************
