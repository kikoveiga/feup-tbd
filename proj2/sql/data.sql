DECLARE
  TYPE PartyArray_T IS TABLE OF Party_T;
  parties PartyArray_T := PartyArray_T(
    Party_T('PPD/PSD', 'Partido Social Democrata',    'direita' ),
    Party_T('CH',      'CHEGA',                       'direita' ),
    Party_T('PS',      'Partido Socialista',          'esquerda'),
    Party_T('IL',      'Iniciativa Liberal',          'direita' ),
    Party_T('L',       'Livre',                       'esquerda'),
    Party_T('PCP',     'Partido Comunista Português', 'esquerda'),
    Party_T('BE',      'Bloco de Esquerda',           'esquerda'),
    Party_T('PAN',     'Pessoas-Animais-Natureza',    'centro'  ),
    Party_T('JPP',     'Juntos pelo Povo',            'centro'  )
  );
BEGIN
  FOR i IN 1 .. parties.COUNT LOOP
    INSERT INTO Parties VALUES (parties(i));
  END LOOP;
END;
/

DECLARE
  TYPE GeoRec IS RECORD (
    code VARCHAR2(10), name VARCHAR2(100), area NUMBER, pop NUMBER
  );
  TYPE GeoArr IS TABLE OF GeoRec;

  nuts1_arr GeoArr := GeoArr(
    GeoRec('PT1', 'Portugal Continental'      , 88889, 9974165),
    GeoRec('PT2', 'Região Autónoma dos Açores', 2322 , 239942  ),
    GeoRec('PT3', 'Região Autónoma da Madeira', 801  , 253259  )
  );

  nuts2_arr GeoArr := GeoArr(
    GeoRec('PT11', 'Norte'                     , 0, 3631502),
    GeoRec('PT15', 'Algarve'                   , 0, 472000 ),
    GeoRec('PT19', 'Centro'                    , 0, 1666684),
    GeoRec('PT1A', 'Península de Setúbal'      , 0, 820305 ),
    GeoRec('PT1B', 'Grande Lisboa'             , 0, 2079365),
    GeoRec('PT1C', 'Alentejo'                  , 0, 471322 ),
    GeoRec('PT1D', 'Oeste e Vale do Tejo'      , 0, 832987 ),
    GeoRec('PT20', 'Região Autónoma dos Açores', 0, 239942 ),
    GeoRec('PT30', 'Região Autónoma da Madeira', 0, 253259 )
  );

  nuts3_arr GeoArr := GeoArr(
    GeoRec('PT111', 'Alto Minho'                 , 0, 232220 ),
    GeoRec('PT112', 'Cávado'                     , 0, 423377 ),
    GeoRec('PT119', 'Ave'                        , 0, 419876 ),
    GeoRec('PT11A', 'Área Metropolitana do Porto', 0, 1774104),
    GeoRec('PT11B', 'Alto Tâmega e Barroso'      , 0, 83463  ),
    GeoRec('PT11C', 'Tâmega e Sousa'             , 0, 408127 ),
    GeoRec('PT11D', 'Douro',                       0, 183418 ),
    GeoRec('PT11E', 'Terras de Trás-os-Montes'   , 0, 106917 ),
    GeoRec('PT150', 'Algarve'                    , 0, 472000 ),
    GeoRec('PT191', 'Região de Aveiro'           , 0, 375698 ),
    GeoRec('PT192', 'Região de Coimbra'          , 0, 439940 ),
    GeoRec('PT193', 'Região de Leiria'           , 0, 290473 ),
    GeoRec('PT194', 'Viseu Dão-Lafões'           , 0, 253154 ),
    GeoRec('PT195', 'Beira Baixa'                , 0, 99046  ),
    GeoRec('PT196', 'Beiras e Serra da Estrela'  , 0, 208373 ),
    GeoRec('PT1A0', 'Península de Setúbal'       , 0, 820305 ),
    GeoRec('PT1B0', 'Grande Lisboa'              , 0, 2079365),
    GeoRec('PT1C1', 'Alentejo Litoral'           , 0, 99111  ),
    GeoRec('PT1C2', 'Baixo Alentejo'             , 0, 115237 ),
    GeoRec('PT1C3', 'Alto Alentejo'              , 0, 104121 ),
    GeoRec('PT1C4', 'Alentejo Central'           , 0, 152853 ),
    GeoRec('PT1D1', 'Oeste'                      , 0, 376961 ),
    GeoRec('PT1D2', 'Médio Tejo'                 , 0, 212796 ),
    GeoRec('PT1D3', 'Lezíria do Tejo'            , 0, 243230 ),
    GeoRec('PT200', 'Região Autónoma dos Açores' , 0, 239942 ),
    GeoRec('PT300', 'Região Autónoma da Madeira' , 0, 253259 )
  );

  parent_ref REF GeoEntity_T;
BEGIN

  -- Insert top-level country (no parent)
  INSERT INTO GeoEntities VALUES (
    GeoEntity_T('PT', 'Portugal', 92012, 10467366, 'country', NULL)
  );

  -- Insert NUTS I
  FOR i IN nuts1_arr.FIRST .. nuts1_arr.LAST LOOP
    SELECT REF(e) INTO parent_ref FROM GeoEntities e WHERE e.code = 'PT';
    INSERT INTO GeoEntities VALUES (
      GeoEntity_T(
        nuts1_arr(i).code,
        nuts1_arr(i).name,
        nuts1_arr(i).area,
        nuts1_arr(i).pop,
        'NUTS I',
        NULL
      )
    );
  END LOOP;

  -- Insert NUTS II (parent = appropriate NUTS I)
  FOR i IN nuts2_arr.FIRST .. nuts2_arr.LAST LOOP
    SELECT REF(e) INTO parent_ref FROM GeoEntities e WHERE e.code = SUBSTR(nuts2_arr(i).code,1,3);
    INSERT INTO GeoEntities VALUES (
      GeoEntity_T(
        nuts2_arr(i).code,
        nuts2_arr(i).name,
        nuts2_arr(i).area,
        nuts2_arr(i).pop,
        'NUTS II',
        parent_ref
      )
    );
  END LOOP;

  -- Insert NUTS III (parent from nuts2)
  FOR i IN nuts3_arr.FIRST .. nuts3_arr.LAST LOOP
    SELECT REF(e) INTO parent_ref FROM GeoEntities e WHERE e.code = SUBSTR(nuts3_arr(i).code,1,4);
    INSERT INTO GeoEntities VALUES (
      GeoEntity_T(
        nuts3_arr(i).code,
        nuts3_arr(i).name,
        nuts3_arr(i).area,
        nuts3_arr(i).pop,
        'NUTS III',
        parent_ref
      )
    );
  END LOOP;

  COMMIT;
END;
/

-- Top-level EXPENSES
INSERT INTO Headings VALUES (
  Heading_T('D1', 'Despesas Correntes', 'D', 1, NULL, Heading_RefList_T())
);

INSERT INTO Headings VALUES (
  Heading_T('D2', 'Despesas de Capital', 'D', 1, NULL, Heading_RefList_T())
);

-- Top-level REVENUES
INSERT INTO Headings VALUES (
  Heading_T('R1', 'Receitas Correntes', 'R', 1, NULL, Heading_RefList_T())
);

INSERT INTO Headings VALUES (
  Heading_T('R2', 'Receitas de Capital', 'R', 1, NULL, Heading_RefList_T())
);

DECLARE
  parent REF Heading_T;
BEGIN
  -- Children of D1
  SELECT REF(h) INTO parent FROM Headings h WHERE h.id = 'D1';
  INSERT INTO Headings VALUES (Heading_T('D1.1', 'Pessoal', 'D', 2, parent, Heading_RefList_T()));
  INSERT INTO Headings VALUES (Heading_T('D1.2', 'Aquisição de Bens e Serviços', 'D', 2, parent, Heading_RefList_T()));
  INSERT INTO Headings VALUES (Heading_T('D1.3', 'Juros da Dívida', 'D', 2, parent, Heading_RefList_T()));

  -- Children of D2
  SELECT REF(h) INTO parent FROM Headings h WHERE h.id = 'D2';
  INSERT INTO Headings VALUES (Heading_T('D2.1', 'Investimentos', 'D', 2, parent, Heading_RefList_T()));
  INSERT INTO Headings VALUES (Heading_T('D2.2', 'Aquisição de Terrenos e Edifícios', 'D', 2, parent, Heading_RefList_T()));

  -- Children of R1
  SELECT REF(h) INTO parent FROM Headings h WHERE h.id = 'R1';
  INSERT INTO Headings VALUES (Heading_T('R1.1', 'Impostos Diretos', 'R', 2, parent, Heading_RefList_T()));
  INSERT INTO Headings VALUES (Heading_T('R1.2', 'Transferências do Estado', 'R', 2, parent, Heading_RefList_T()));

  -- Children of R2
  SELECT REF(h) INTO parent FROM Headings h WHERE h.id = 'R2';
  INSERT INTO Headings VALUES (Heading_T('R2.1', 'Venda de Bens de Investimento', 'R', 2, parent, Heading_RefList_T()));
  INSERT INTO Headings VALUES (Heading_T('R2.2', 'Transferências de Capital', 'R', 2, parent, Heading_RefList_T()));
END;
/

DECLARE
  TYPE MunRec IS RECORD (
    code         VARCHAR2(10),
    name         VARCHAR2(100),
    area         NUMBER,
    pop          NUMBER,
    parent_code  VARCHAR2(10),
    party_acr    VARCHAR2(10),
    budget_amt   NUMBER
  );
  TYPE MunArr IS TABLE OF MunRec;

  municipalities MunArr := MunArr(
    MunRec('LIS', 'Lisboa',   100.05, 545923,  'PT1B0', 'PS',     250000),
    MunRec('PRT', 'Porto',     41.42, 232125,  'PT11A', 'PPD/PSD',180000),
    MunRec('BRG', 'Braga',    183.4,  193333,  'PT112', 'PS',     120000),
    MunRec('AVR', 'Aveiro',   197.58, 80555,   'PT191', 'IL',      95000),
    MunRec('CBR', 'Coimbra',  319.4,  143396,  'PT192', 'PCP',    105000),
    MunRec('LEI', 'Leiria',   565.1,  128640,  'PT193', 'BE',      88000)
  );

  parent_ref REF GeoEntity_T;
  party_ref  REF Party_T;
  heading_ref REF Heading_T;

  budgets BudgetList_T;
  leads LeadershipList_T;
BEGIN
  -- Get heading once (e.g., D1.1 = Pessoal)
  SELECT REF(h) INTO heading_ref FROM Headings h WHERE h.id = 'D1.1';

  FOR i IN municipalities.FIRST .. municipalities.LAST LOOP
    -- Get parent NUTS III
    SELECT REF(e) INTO parent_ref FROM GeoEntities e WHERE e.code = municipalities(i).parent_code;

    -- Get party ref
    SELECT REF(p) INTO party_ref FROM Parties p WHERE p.acronym = municipalities(i).party_acr;

    -- Create nested budgets
    budgets := BudgetList_T();
    budgets.EXTEND;
    budgets(1) := BudgetEntry_T(
      'D',
      Period_T(2023, '1'),
      municipalities(i).budget_amt,
      heading_ref
    );

    -- Create nested leaderships
    leads := LeadershipList_T();
    leads.EXTEND;
    leads(1) := Leadership_T(Period_T(2023, NULL), party_ref);

    -- Insert municipality
    INSERT INTO Municipalities VALUES (
      Municipality_T(
        municipalities(i).code,
        municipalities(i).name,
        municipalities(i).area,
        municipalities(i).pop,
        'municipality',
        parent_ref,
        budgets,
        leads
      )
    );
  END LOOP;

  COMMIT;
END;
/