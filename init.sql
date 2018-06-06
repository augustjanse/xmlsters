CREATE TABLE user (
  userid  VARCHAR(255) NOT NULL,
  chartid VARCHAR(255) NOT NULL,
  PRIMARY KEY (chartid)
);

CREATE TABLE chart (
  chartid   VARCHAR(255) NOT NULL,
  placement INT          NOT NULL,
  mbid      VARCHAR(255) NOT NULL,
  PRIMARY KEY (chartid, placement),
  FOREIGN KEY (chartid) REFERENCES user (chartid)
);

INSERT INTO user (userid, chartid) VALUES (1, 123);
INSERT INTO user (userid, chartid) VALUES (2, 124);

INSERT INTO chart VALUES (123, 1, 'ce28234a-a14a-450f-a1a2-864b5f30499e');
INSERT INTO chart VALUES (123, 7, 'ae788513-5241-49a0-9da6-61d3c69a6357');
INSERT INTO chart VALUES (124, 12, '8590421a-5141-4dbd-ae85-374fb8ecda68');
