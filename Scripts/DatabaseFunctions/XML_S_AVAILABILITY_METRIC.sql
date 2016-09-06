﻿-- Function: "WADE_R"."XML_S_AVAILABILITY_METRIC"(text, text, text, numeric)

-- DROP FUNCTION "WADE_R"."XML_S_AVAILABILITY_METRIC"(text, text, text, numeric);

CREATE OR REPLACE FUNCTION "WADE_R"."XML_S_AVAILABILITY_METRIC"(
    IN orgid text,
    IN reportid text,
    IN reportunitid text,
    IN seqno numeric,
    OUT tmp_output xml)
  RETURNS xml AS
$BODY$

BEGIN

tmp_output:=(SELECT STRING_AGG
	(XMLELEMENT
		(name "WC:AvailabilityMetric", 
			(SELECT XMLFOREST
				(D."VALUE" AS "WC:MetricName",
				"METRIC_VALUE" AS "WC:MetricValue",
				"METRIC_SCALE" AS "WC:MetricScaleNumber",
				"REVERSE_SCALE_IND" AS "WC:ReverseScaleIndicator")
			),
			XMLELEMENT
				(name "WC:Method",
					(SELECT XMLFOREST
						(C."METHOD_CONTEXT" AS "WC:MethodContext",
						C."METHOD_NAME" AS "WC:MethodName")
					)
				),
				XMLELEMENT
					(name "WC:TimeFrame",
						(SELECT XMLFOREST
							("START_DATE" AS "WC:TimeFrameStartName", 
							"END_DATE" AS "WC:TimeFrameEndName")
						)
					)
		)::text,''
	)

	FROM  

	"WADE"."S_AVAILABILITY_METRIC" A LEFT JOIN "WADE"."METHODS" C ON (A."METHOD_ID"=C."METHOD_ID")
	LEFT JOIN "WADE"."METRICS" D ON (A."METRIC_ID"=D."METRIC_ID")

	WHERE 

	"ORGANIZATION_ID"=orgid AND "REPORT_ID"=reportid AND "REPORT_UNIT_ID"=reportunitid AND "SUMMARY_SEQ"=seqno);

	RETURN;

		

END



  $BODY$
  LANGUAGE plpgsql VOLATILE
  COST 1000;
ALTER FUNCTION "WADE_R"."XML_S_AVAILABILITY_METRIC"(text, text, text, numeric)
  OWNER TO "WADE";
