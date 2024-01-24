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
// - Ativa o Objeto Browser para sua exibicao.
oBrowse:Activate()
Return

***********************
// Monta Painel de Controle do Browser Principal.
Static Function MenuDef()
Local aRotina := {}

// - Adciona itens ao Array aRotina.
ADD OPTION aRotina Title 'Pesquisar' Action "AxPesqui" OPERATION 1 ACCESS 0
ADD OPTION aRotina Title 'Visualizar' Action "AxVisual" OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir' Action "U_fCadZA1M(3)" OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar' Action "U_fCadZA1M(4)" OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir' Action "U_fCadZA1M(5)" OPERATION 5 ACCESS 0

Return aRotina
**************************************************************************************************************************************************************************

/*
AxInclui(cAlias,nReg,nOpc,aAcho,cFunc,aCpos,cTudoOk,lF3,cTransact,aButtons,aParam,aAuto,lVirtual,lMaximized,cTela,lPanelFin,oFather,aDim,uArea,lFlat,lSubst)
AxAltera(cAlias,nReg,nOpc,aAcho,aCpos,nColMens,cMensagem,cTudoOk,cTransact,cFunc,aButtons,aParam,aAuto,lVirtual,lMaximized,cTela,lPanelFin,oFather,aDim,uArea,lFlat)
Function AxDeleta(cAlias,nReg,nOpc,cTransact,aCpos,aButtons,aParam,aAuto,lMaximized,cTela,aAcho,lPanelFin,oFather,aDim, lFlat)				
*/				

// Função principal que chama AxInclui
User Function fCadZA1M(nOpc)
	Local cTudoOk := "U_fUpdZA1()"
	// Parâmetros adicionais conforme necessário
	Local aParam := []

	If nOpc == 3	// Inclusão
		AxInclui("ZA1", 0, 3, ,,,cTudoOk)
	ElseIf nOpc == 4
		AxAltera("ZA1", ZA1->(Recno()), 4, ,,,,cTudoOk)
	ElseIf nOpc == 5
		AxDeleta("ZA1", ZA1->(Recno()), 5)
	EndIf

Return


/*/ {Protheus.doc} Function
// Função estática que faz o reclock e o update

User Function fUpdZA1()
   Local cA5_FABR := M->A5_XFABR
   Local cZ1_DESC := M->Z1_DESC

   // Construa a instrução SQL para realizar o update
   Local cSQL := "UPDATE " + RetSqlName("SA5") + ;
                    "SET A5_FABR = '" + cZ1_DESC + "'" + ;
                 " WHERE A5_FILIAL = '" + xFilial("SA5") + "' AND A5_XFABR = '" + cA5_FABR + "'"

   // Execução do update
   If (TCSQLExec(cSQL) <> 0)
      // Se houver um erro, emita uma mensagem de erro
      Help(,, "fUpdZA1",, "Erro ao atualizar A5_FABR", 1, 0)
      Return .F.
   EndIf

Return .T.
