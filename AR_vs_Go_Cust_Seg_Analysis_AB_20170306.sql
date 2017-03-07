/*

Bartos - 20170306

ACTIVATION REP vs. PM GO Customer Segmentation Analysis

OBJECTIVES:
- breakdown of AR activity:
    - 1 -which custs for direct products - # custs/who
    - 2- which engaged to sign up on Go with links - direct links - #/who
    - 3 -attribution model- who/#
    - account name, brand, size, locations, parent, employees, etc., opp amt where available
    - account overview table - view, locations C, brand, parent, name, size
    - dump of abandon carts... us to analyze that list - parse gmail, etc, how many in SF as a contact
    
ADDITIONAL BACKGROUND INFO:    
- channel conflict b/w PM Go rev targets and AR rev targets
- issue: PM Go team $8M rev target - worried some is being taken by direct sales team (ARs)
- goal: show Jocelyn/V what makes sense
    - data to back up sales strategy
- Megan meeting in 3 weeks to present findings/recs on what sales strategy looks like:
    - based on cust persona, types of custs sales should sell to (for ARs)
    - custs best for eComm persona?
    - custs best for AR team/direct sales?
    - of accts that started as ecomm leads, which had SF opps are closed/won? what do these custs look like?
    - ecomm - metric orphan
    - activation reps - sales strategy
    - what is right type of cust for activation rep vs. ecomm
    - ecomm 1-2 locs, mom/pop
    - ARs focus on brands/franchises
    - opp size, brand, characteristics
*/


---------------------------------------------------------------------CREATE ISR TEAM TABLE---------------------------------------------------------------------
--Pull current ISR team member        
        DROP TABLE IF EXISTS prod_saj_share.work_revopt.ISR;
        CREATE TEMPORARY TABLE prod_saj_share.work_revopt.ISR AS (   
        SELECT u.name
                ,u.id
                ,u.snagajob_dept_c
                ,u.title
                ,replace(split_part(u.snagajob_dept_c,' : ', 2), 'Executives') sales_team 
                ,COALESCE((CASE WHEN split_part(u.snagajob_dept_c,' : ', 4) = '' THEN NULL
                        WHEN title LIKE '%Lead%' THEN (split_part(u.snagajob_dept_c,' : ', 4)||' - ')||title
                        WHEN title LIKE '%Manager%' THEN (split_part(u.snagajob_dept_c,' : ', 4)||' - ')||title
                        ELSE split_part(u.snagajob_dept_c,' : ', 4) END),split_part(u.snagajob_dept_c,' : ', 3)) AS owner_role
                ,CASE WHEN name IN ('Adam Vanderhoof', 'Richard Snelling', 'Ned Lockwood', 'Adam Teitelman') THEN 'Activation Rep'
                        WHEN name IN ('Anthony Rodrigues', 'Michael August', 'Dylan Wood', 'Sergio Birch', 'Brandi Cowans', 'Leah Steinke') THEN 'Associate, Mid Market' 
                        WHEN name = 'Autumn Grigg' AND current_date < '20170301' THEN 'Associate, Mid Market'
                        WHEN name = 'Autumn Grigg' AND current_date >= '20170301' THEN 'Activation Rep'
                        WHEN name IN ('Kolden Buehler', 'Michael Kolbe', 'Andrew Grover') THEN 'Associate, Enterprise'
                        WHEN name IN ('Will Morse', 'Jessica Spence', 'Liz Hough') THEN 'Manager/Team Lead'
                        END AS position
        FROM prod_saj_share.salesforce.user u
        WHERE 1=1
                AND snagajob_dept_c LIKE '%Sales : 250%'
                AND position IS NOT NULL
        );
        
        SELECT * FROM prod_saj_share.work_revopt.ISR


---------------------------------------------------------------------CREATE ACCOUNT TEMP TABLE---------------------------------------------------------------------       
        DROP TABLE IF EXISTS prod_saj_share.work_revopt.araccounts;
        CREATE TEMPORARY TABLE prod_saj_share.work_revopt.araccounts AS (    
                SELECT a.id ecomm_account_id
                        ,a.ns_id_c
                        ,a.name ecomm_name
                        ,a.created_date
                        ,pa.id parent_id
                        ,pa.name parent_name
                FROM prod_saj_share.salesforce.account a
                LEFT JOIN prod_saj_share.salesforce.account pa on a.parent_id = pa.id
                WHERE a.id IN (
                '0011a00000bxTYlAAM',
                '0011a00000bxc2pAAA',
                '0011a00000byMe0AAE',
                '0011a00000cWlwcAAC',
                '0011a00000bxtbxAAA',
                '0011a00000byMacAAE',
                '0011a00000bxTXtAAM',
                '0011a00000cXwSLAA0',
                '0011a00000bxTY2AAM',
                '0011a00000cWVvQAAW',
                '0011a00000byPE1AAM',
                '0011a00000cWVzXAAW',
                '0011a00000cWrjLAAS',
                '0011a00000byMcJAAU',
                '0011a00000byPHmAAM',
                '0011a00000byPFbAAM',
                '0011a00000byPC3AAM',
                '0011a00000cX9fGAAS',
                '0011a00000byMb6AAE',
                '0011a00000cWQ0dAAG',
                '0011a00000cWCR1AAO',
                '0011a00000bxkr0AAA',
                '0011a00000bxkr5AAA',
                '0011a00000bxte2AAA',
                '0011a00000cX9fBAAS',
                '0011a00000cWCQDAA4',
                '0011a00000cWCSEAA4',
                '0011a00000byMd2AAE',
                '0011a00000cWCSTAA4',
                '0011a00000bxc2fAAA',
                '0011a00000cXUviAAG',
                '0011a00000cXUu1AAG',
                '0011a00000bcQPrAAM',
                '0011a00000bcQQuAAM',
                '0011a00000bcRiFAAU',
                '0011a00000bcYBBAA2',
                '0011a00000bcYBQAA2',
                '0011a00000bcgXEAAY',
                '0011a00000bcvF8AAI',
                '0011a00000bdM6NAAU',
                '0011a00000bdM7KAAU',
                '0011a00000bdRIWAA2',
                '0011a00000bdRKSAA2',
                '0011a00000bvpZqAAI',
                '0011a00000bvpbXAAQ',
                '0011a00000bvx9BAAQ',
                '0011a00000bwazDAAQ',
                '0011a00000bwi35AAA',
                '0011a00000bwm9tAAA',
                '0011a00000bwm9yAAA',
                '0011a00000bwtxgAAA',
                '0011a00000bwty0AAA',
                '0011a00000bwvrJAAQ',
                '0011a00000bwzTAAAY',
                '0011a00000bwzUmAAI',
                '0011a00000bx4zSAAQ',
                '0011a00000bx4zmAAA',
                '0011a00000bxBozAAE'        
               )                
        );
        
        SELECT * FROM prod_saj_share.work_revopt.araccounts


---------------------------------------------------------------------CREATE PARENT TEMP TABLE (FROM LIST)---------------------------------------------------------------------                    
        DROP TABLE IF EXISTS prod_saj_share.work_revopt.arparents;
        CREATE TEMPORARY TABLE prod_saj_share.work_revopt.arparents AS (    
                SELECT parent_id parent_account_id
                        ,parent_name parent_name
                FROM prod_saj_share.work_revopt.araccounts a
                WHERE parent_id IS NOT NULL           
        );
        
        SELECT * FROM prod_saj_share.work_revopt.arparents
                          
     
---------------------------------------------------------------------CREATE ECOMM TRANSFER LIST TO EXCLUDE---------------------------------------------------------------------                    
        DROP TABLE IF EXISTS prod_saj_share.work_revopt.transferexclude;
        CREATE TEMPORARY TABLE prod_saj_share.work_revopt.transferexclude AS (    
                SELECT * FROM (
                SELECT DISTINCT a.id 
                        ,a.name
                        ,a.created_date
                        ,act.completed_date_ts
                        ,act.activity_id
                        ,act.subject
                        ,row_number() OVER (PARTITION BY a.id ORDER BY act.completed_date_ts ASC) rn
                FROM prod_saj_share.salesforce.account a
                LEFT JOIN prod_saj_share.work_revopt.salesforce_completed_activity act ON act.account_id = a.id            
                WHERE 1=1
                        AND a.record_type_id = '0121a0000002GX9AAM' --eComm customer
                        AND act.subject LIKE '%Ecomm Retention Transfer Task%'
                        AND act.completed_date_ts BETWEEN '2017-01-01' AND '2017-02-28'
                ) WHERE rn = 1
        );
        
        SELECT * FROM prod_saj_share.work_revopt.transferexclude

                                
---------------------------------------------------------------------CHECK WHICH ACCOUNTS HAD AR ACTIVITY ON PARENT ACCOUNT--------------------------------------------------------------------- 
        DROP TABLE IF EXISTS prod_saj_share.work_revopt.parentactivity;
        CREATE TEMPORARY TABLE prod_saj_share.work_revopt.parentactivity AS (   
        SELECT s.*, 'Parent Activity' creation_type FROM (
                SELECT ar.*
                        ,isr.name
                        ,act.*
                        ,row_number() OVER (PARTITION BY ar.ecomm_account_id ORDER BY act.completed_date_ts DESC) rn
                FROM prod_saj_share.work_revopt.araccounts ar
                LEFT JOIN prod_saj_share.work_revopt.salesforce_completed_activity act ON (act.account_id = ar.parent_id) AND act.completed_date_ts BETWEEN timestampadd(day,-7,ar.created_date) AND ar.created_date
                JOIN prod_saj_share.work_revopt.ISR isr ON act.person_id = isr.id AND isr.position = 'Activation Rep'
                WHERE 1=1
                        AND (type IN ('Call','Webinar','Phone','Inmail','Closing Call') OR sub_type LIKE '%Presentation%' OR (email_direction = 'OB' AND outreach_flag = 0) OR (email_direction = 'IB'))
                        AND sub_type <> 'Presentation - Telecon'
                ) s
        WHERE 1=1
                AND rn = 1
        );
        
        SELECT * FROM prod_saj_share.work_revopt.parentactivity           


---------------------------------------------------------------------CHECK WHICH ACCOUNTS USED A DIRECT LINK (Orphan Opps)--------------------------------------------------------------------- 
        DROP TABLE IF EXISTS prod_saj_share.work_revopt.directlink;
        CREATE TEMPORARY TABLE prod_saj_share.work_revopt.directlink AS (   
        SELECT ar.*
                ,isr.name
                ,op.*
                ,'Direct Link' creation_type 
        FROM prod_saj_share.work_revopt.araccounts ar
        LEFT JOIN (
                SELECT DISTINCT o.account_id
                        ,o.name opp_name
                        ,o.created_date opp_created_date
                        ,o.close_date
                        ,o.owner_id
                        ,row_number() OVER(PARTITION BY account_id ORDER BY o.created_date ASC) rn
                FROM prod_saj_share.salesforce.opportunity o
                WHERE o.name LIKE '%rphan%'
                        AND o.opportunity_product_c LIKE '%SMB%'
                ) op ON ar.ecomm_account_id = op.account_id AND close_date BETWEEN timestampadd(day,-7,ar.created_date) AND ar.created_date AND rn = 1
        JOIN prod_saj_share.work_revopt.ISR isr ON op.owner_id = isr.id AND isr.position = 'Activation Rep'
        );
        
        SELECT * FROM prod_saj_share.work_revopt.directlink               
       
 
---------------------------------------------------------------------CONFIRM ACCOUNTS FROM PARENT ACTIVITY OR DIRECT LINK--------------------------------------------------------------------- 
        DROP TABLE IF EXISTS prod_saj_share.work_revopt.ARsignups;
        CREATE TEMPORARY TABLE prod_saj_share.work_revopt.ARsignups AS (   
        SELECT * FROM (
        SELECT DISTINCT CASE WHEN pa.ecomm_account_id IS NOT NULL THEN 'Yes' ELSE 'No' END AS Parent_Activity
                ,CASE WHEN dl.ecomm_account_id IS NOT NULL THEN 'Yes' ELSE 'No' END AS Direct_Link
                ,'Yes' AS On_Provided_List
                ,CASE WHEN tex.id IS NOT NULL THEN 'Yes' ELSE 'No' END AS eComm_Retention_Transfer_Task
                ,tex.completed_date_ts transfer_task_date
                ,ar.*
        FROM prod_saj_share.work_revopt.araccounts ar
        LEFT JOIN prod_saj_share.work_revopt.parentactivity pa on ar.ecomm_account_id = pa.ecomm_account_id
        LEFT JOIN prod_saj_share.work_revopt.directlink dl on ar.ecomm_account_id = dl.ecomm_account_id
        LEFT JOIN prod_saj_share.work_revopt.transferexclude tex on ar.ecomm_account_id = tex.id
        )
        );
        
        SELECT * FROM prod_saj_share.work_revopt.ARsignups

---------------------------------------------------------------------PULL AR SIGN UPS DATA--------------------------------------------------------------------- 
        DROP TABLE IF EXISTS prod_saj_share.work_revopt.ARsignupsfinal;
        CREATE TEMPORARY TABLE prod_saj_share.work_revopt.ARsignupsfinal AS (         
        SELECT ecomm_account_id
                ,sfa.ns_id_c 
                ,ar.ecomm_name
                ,ar.parent_id
                ,ar.parent_name
                ,ar.created_date
                ,parent_activity
                ,direct_link
        FROM prod_saj_share.work_revopt.ARsignups ar
        LEFT JOIN prod_saj_share.salesforce.account sfa ON ar.ecomm_account_id = sfa.id      
        );
        
        
--Count Summary        
        SELECT SUM(CASE WHEN parent_activity = 'Yes' THEN 1 ELSE 0 END) AS Cnt_Parent_Activity
                ,SUM(CASE WHEN direct_link = 'Yes' THEN 1 ELSE 0 END) AS Cnt_Direct_Link
                ,SUM(CASE WHEN parent_activity = 'No' AND direct_link = 'No' THEN 1 ELSE 0 END) AS Cnt_Unclear
                ,COUNT(DISTINCT(ecomm_account_id)) AS Total_Signups
        FROM prod_saj_share.work_revopt.ARsignupsfinal 


--Pull in attributes for AR sign-ups       
        SELECT ar.*
                ,CASE WHEN sfo.brand_name IS NULL THEN 'No Brand' ELSE sfo.brand_name END AS brand
                ,sfo.under_contract_c
                ,sfo.account_record_type
                ,sfo.number_of_employees
                ,sfa.site
                ,sfo.of_locations_c
                ,inv.amount_c
                ,inv.name AS invoice_item
                ,inv.rev_rec_start_date_c
                ,inv.rev_rec_end_date_c
        FROM prod_saj_share.work_revopt.ARsignupsfinal ar
        LEFT JOIN prod_saj_share.work_revopt.salesforce_account_overview sfo ON ar.ecomm_account_id = sfo.account_id
        LEFT JOIN prod_saj_share.salesforce.account sfa ON ar.ecomm_account_id = sfa.id
        LEFT JOIN prod_saj_share.salesforce."ORDER" ord ON ar.ecomm_account_id = ord.account_id
        LEFT JOIN prod_saj_share.salesforce.order_invoice_items_c inv ON ord.id = inv.order_invoice_c
        WHERE inv.rev_rec_start_date_c BETWEEN '20170101' AND '20170228' 
        
        
--Pull in same data for Go eComm signups  
        SELECT sfa.id go_account_id
                ,sfa.ns_id_c
                ,sfa.name go_name
                ,sfp.id parent_id
                ,sfp.name parent_name
                ,sfa.created_date
                ,'N/A' parent_activity
                ,'N/A' direct_link
                ,CASE WHEN sfo.brand_name IS NULL THEN 'No Brand' ELSE sfo.brand_name END AS brand
                ,sfo.under_contract_c
                ,sfo.account_record_type
                ,sfo.number_of_employees
                ,sfa.site
                ,sfo.of_locations_c
                ,inv.amount_c
                ,inv.name AS invoice_item
                ,inv.rev_rec_start_date_c
                ,inv.rev_rec_end_date_c
        FROM prod_saj_share.salesforce.account sfa
        LEFT JOIN prod_saj_share.salesforce.account sfp on sfa.parent_id = sfp.id
        LEFT JOIN prod_saj_share.work_revopt.salesforce_account_overview sfo ON sfa.id = sfo.account_id
        LEFT JOIN prod_saj_share.salesforce."ORDER" ord ON sfa.id = ord.account_id
        LEFT JOIN prod_saj_share.salesforce.order_invoice_items_c inv ON ord.id = inv.order_invoice_c
        LEFT JOIN prod_saj_share.work_revopt.ARsignupsfinal ar ON sfa.id = ar.ecomm_account_id
        LEFT JOIN (
                        SELECT DISTINCT o.account_id opp_account_id
                                ,o.close_date
                                ,u.name opp_owner
                        FROM prod_saj_share.salesforce.opportunity o
                        LEFT JOIN prod_saj_share.salesforce.user u ON o.owner_id = u.id
                        WHERE o.name LIKE '%rphan%'
                                AND o.opportunity_product_c LIKE '%SMB%'
                        ) b ON sfa.id = b.opp_account_id
        WHERE 1=1
                AND ar.ecomm_account_id IS NULL
                AND b.opp_account_id IS NULL
                AND sfa.created_date BETWEEN '2017-01-01' AND '2017-02-28' 
                AND inv.rev_rec_start_date_c BETWEEN '20170101' AND '20170228' 
                AND inv.name LIKE '%SMB%'

      